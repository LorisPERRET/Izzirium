//
//  BlePairingCentralManager.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
//

import Combine
@preconcurrency import CoreBluetooth
import Foundation
import SKDependencyInjection

public enum BLEBluetoothState: Equatable, Sendable {

    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
}

public protocol BlePairingCentralManagerProtocol: ObservableObject {

    var bluetoothState: BLEBluetoothState { get }
    var discoveredDevices: [DiscoveredBLEDevice] { get }
    var connectedDevice: PairingDeviceIdentity? { get }
    var bluetoothStatePublisher: AnyPublisher<BLEBluetoothState, Never> { get }
    var discoveredDevicesPublisher: AnyPublisher<[DiscoveredBLEDevice], Never> { get }

    func startScan() throws
    func stopScan()
    func connect(to device: DiscoveredBLEDevice) async throws -> PairingDeviceIdentity
    func disconnectCurrentDevice()
    func sendProvisioning(_ credentials: PairingCredentials) async throws
    func readProvisioningStatus() async throws -> PairingProvisioningStatus
}

final class BlePairingCentralManager: NSObject, BlePairingCentralManagerProtocol {

    @Published private(set) var bluetoothState: BLEBluetoothState = .unknown
    @Published private(set) var discoveredDevices: [DiscoveredBLEDevice] = []
    @Published private(set) var connectedDevice: PairingDeviceIdentity?

    var bluetoothStatePublisher: AnyPublisher<BLEBluetoothState, Never> {
        $bluetoothState.eraseToAnyPublisher()
    }

    var discoveredDevicesPublisher: AnyPublisher<[DiscoveredBLEDevice], Never> {
        $discoveredDevices.eraseToAnyPublisher()
    }

    private let configuration: BLEPairingConfiguration
    private let logger = Logger(category: BlePairingCentralManager.self)

    private lazy var centralManager = CBCentralManager(delegate: self, queue: nil)

    private var peripheralByIdentifier: [String: CBPeripheral] = [:]
    private var currentPeripheral: CBPeripheral?
    private var wifiConfigurationCharacteristic: CBCharacteristic?
    private var provisioningStatusCharacteristic: CBCharacteristic?
    private var connectContinuation: CheckedContinuation<Void, Error>?
    private var characteristicDiscoveryContinuation: CheckedContinuation<Void, Error>?
    private var writeContinuation: CheckedContinuation<Void, Error>?
    private var provisioningStatusContinuation: CheckedContinuation<PairingProvisioningStatus, Error>?
    private var provisioningStatusTimeoutWorkItem: DispatchWorkItem?
    private var pendingProvisioningStatus: PairingProvisioningStatus?

    init(
        configuration: BLEPairingConfiguration = .default
    ) {
        self.configuration = configuration
        super.init()

        // Trigger CoreBluetooth initialization so the delegate receives the real authorization/state.
        _ = centralManager
    }

    func startScan() throws {
        guard bluetoothState == .poweredOn else {
            throw bluetoothState == .unauthorized ? PairingError.bluetoothUnauthorized : PairingError.bluetoothUnavailable
        }

        discoveredDevices.removeAll()
        peripheralByIdentifier.removeAll()

        centralManager.scanForPeripherals(
            withServices: configuration.serviceUUIDs.map(CBUUID.init(string:)),
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: false
            ]
        )
    }

    func stopScan() {
        centralManager.stopScan()
    }

    func connect(to device: DiscoveredBLEDevice) async throws -> PairingDeviceIdentity {
        guard bluetoothState == .poweredOn else {
            throw PairingError.bluetoothUnavailable
        }

        guard let peripheral = peripheralByIdentifier[device.id] else {
            throw PairingError.deviceNotFound
        }

        currentPeripheral = peripheral
        wifiConfigurationCharacteristic = nil
        provisioningStatusCharacteristic = nil
        pendingProvisioningStatus = nil
        centralManager.connect(peripheral, options: nil)

        try await withCheckedThrowingContinuation { continuation in
            connectContinuation = continuation
        }

        let identity = PairingDeviceIdentity(
            deviceId: device.id,
            name: device.name,
            model: device.model,
            firmwareVersion: device.firmwareVersion,
            isPairingMode: device.isPairingMode
        )

        connectedDevice = identity

        peripheral.discoverServices(configuration.serviceUUIDs.map(CBUUID.init(string:)))
        try await withCheckedThrowingContinuation { continuation in
            characteristicDiscoveryContinuation = continuation
        }

        return identity
    }

    func disconnectCurrentDevice() {
        guard let currentPeripheral else { return }
        centralManager.cancelPeripheralConnection(currentPeripheral)
    }

    func sendProvisioning(_ credentials: PairingCredentials) async throws {
        guard let currentPeripheral else {
            throw PairingError.deviceNotFound
        }

        guard let wifiConfigurationCharacteristic else {
            throw PairingError.provisioningFailed(reason: "Characteristic d'ecriture Wi-Fi introuvable.")
        }

        let payload = "\(credentials.wifiSSID)|\(credentials.wifiPassword)|\(credentials.sensorId)"

        guard let data = payload.data(using: .utf8) else {
            throw PairingError.invalidConfiguration(reason: "Impossible d'encoder la configuration Wi-Fi.")
        }

        logger.info("Sending Wi-Fi payload to \(currentPeripheral.identifier.uuidString)")

        try await withCheckedThrowingContinuation { continuation in
            writeContinuation = continuation
            currentPeripheral.writeValue(data, for: wifiConfigurationCharacteristic, type: .withResponse)
        }
    }

    func readProvisioningStatus() async throws -> PairingProvisioningStatus {
        guard let currentPeripheral else {
            throw PairingError.deviceNotFound
        }

        guard let provisioningStatusCharacteristic else {
            throw PairingError.provisioningFailed(reason: "Characteristic de statut introuvable.")
        }

        if let pendingProvisioningStatus {
            self.pendingProvisioningStatus = nil
            return pendingProvisioningStatus
        }

        if provisioningStatusCharacteristic.isNotifying == false {
            currentPeripheral.setNotifyValue(true, for: provisioningStatusCharacteristic)
        }
        provisioningStatusTimeoutWorkItem?.cancel()

        return try await withCheckedThrowingContinuation { continuation in
            provisioningStatusContinuation = continuation

            let timeoutWorkItem = DispatchWorkItem { [weak self] in
                self?.resumeProvisioningStatusContinuation(with: .failure(PairingError.timeout))
            }

            provisioningStatusTimeoutWorkItem = timeoutWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: timeoutWorkItem)
        }
    }
}

extension BlePairingCentralManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        logger.info("CoreBluetooth state updated: \(describe(central.state))")

        bluetoothState = switch central.state {
        case .unknown:
            .unknown
        case .resetting:
            .resetting
        case .unsupported:
            .unsupported
        case .unauthorized:
            .unauthorized
        case .poweredOff:
            .poweredOff
        case .poweredOn:
            .poweredOn
        @unknown default:
            .unknown
        }

        logger.info("Mapped BLE state: \(String(describing: bluetoothState))")
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        _ = central

        let identifier = peripheral.identifier.uuidString
        peripheralByIdentifier[identifier] = peripheral

        let localName = peripheral.name ?? "Objet sans nom"
        let serviceUUIDs = (advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []).map(\.uuidString)

        if let prefix = configuration.deviceNamePrefix, !localName.hasPrefix(prefix) {
            return
        }

        let device = DiscoveredBLEDevice(
            id: identifier,
            name: localName,
            rssi: RSSI.intValue,
            model: nil,
            firmwareVersion: nil,
            isPairingMode: true,
            advertisedServiceUUIDs: serviceUUIDs
        )

        upsert(device)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        _ = central
        peripheral.delegate = self
        connectContinuation?.resume()
        connectContinuation = nil
        logger.info("Connected to peripheral: \(peripheral.identifier.uuidString)")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        _ = central
        _ = peripheral
        connectContinuation?.resume(throwing: PairingError.connectionFailed(reason: error?.localizedDescription))
        connectContinuation = nil
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        _ = central

        if currentPeripheral?.identifier == peripheral.identifier {
            currentPeripheral = nil
            connectedDevice = nil
            wifiConfigurationCharacteristic = nil
            provisioningStatusCharacteristic = nil
            pendingProvisioningStatus = nil
        }

        resumeProvisioningStatusContinuation(
            with: .failure(
                PairingError.connectionFailed(
                    reason: error?.localizedDescription ?? "La connexion Bluetooth a ete interrompue."
                )
            )
        )

        if let error {
            logger.error("Disconnected from peripheral with error: \(error.localizedDescription)")
        }
    }
}

extension BlePairingCentralManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error {
            logger.error("didDiscoverServices failed: \(error.localizedDescription)")
            characteristicDiscoveryContinuation?.resume(throwing: PairingError.connectionFailed(reason: error.localizedDescription))
            characteristicDiscoveryContinuation = nil
            return
        }

        peripheral.services?.forEach { service in
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        if let error {
            logger.error("didDiscoverCharacteristicsFor \(service.uuid.uuidString) failed: \(error.localizedDescription)")
            characteristicDiscoveryContinuation?.resume(throwing: PairingError.connectionFailed(reason: error.localizedDescription))
            characteristicDiscoveryContinuation = nil
            return
        }

        if let wifiCharacteristic = service.characteristics?.first(where: {
            $0.uuid == CBUUID(string: configuration.characteristics.wifiConfigurationWrite)
        }) {
            wifiConfigurationCharacteristic = wifiCharacteristic
            logger.info("Wi-Fi write characteristic found: \(wifiCharacteristic.uuid.uuidString)")
        }

        if let statusCharacteristic = service.characteristics?.first(where: {
            $0.uuid == CBUUID(string: configuration.characteristics.provisioningStatus)
        }) {
            provisioningStatusCharacteristic = statusCharacteristic
            logger.info("Provisioning status characteristic found: \(statusCharacteristic.uuid.uuidString)")
            peripheral.setNotifyValue(true, for: statusCharacteristic)
        }

        if wifiConfigurationCharacteristic != nil, provisioningStatusCharacteristic != nil {
            characteristicDiscoveryContinuation?.resume()
            characteristicDiscoveryContinuation = nil
        } else if service.uuid == CBUUID(string: configuration.serviceUUIDs.first ?? "") {
            logger.error("Required pairing characteristics not found in service \(service.uuid.uuidString)")
        }
    }

    func peripheral(
        _ peripheral: CBPeripheral,
        didWriteValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        _ = peripheral

        if let error {
            logger.error("didWriteValueFor \(characteristic.uuid.uuidString) failed: \(error.localizedDescription)")
            writeContinuation?.resume(throwing: PairingError.provisioningFailed(reason: error.localizedDescription))
            writeContinuation = nil
            return
        }

        logger.info("Wi-Fi payload written on \(characteristic.uuid.uuidString)")
        writeContinuation?.resume()
        writeContinuation = nil
    }

    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateNotificationStateFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        _ = peripheral

        if let error {
            logger.error("didUpdateNotificationStateFor \(characteristic.uuid.uuidString) failed: \(error.localizedDescription)")
            resumeProvisioningStatusContinuation(with: .failure(PairingError.provisioningFailed(reason: error.localizedDescription)))
            return
        }

        logger.info("Notification state updated for \(characteristic.uuid.uuidString): \(characteristic.isNotifying)")
    }

    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        _ = peripheral

        if let error {
            logger.error("didUpdateValueFor \(characteristic.uuid.uuidString) failed: \(error.localizedDescription)")
            resumeProvisioningStatusContinuation(with: .failure(PairingError.provisioningFailed(reason: error.localizedDescription)))
            return
        }

        guard characteristic.uuid == CBUUID(string: configuration.characteristics.provisioningStatus) else {
            return
        }

        guard let status = decodeProvisioningStatus(from: characteristic.value) else {
            logger.info("Ignoring empty provisioning status on \(characteristic.uuid.uuidString)")
            return
        }
        logger.info("Provisioning status received on \(characteristic.uuid.uuidString): \(String(describing: status))")

        if provisioningStatusContinuation == nil {
            pendingProvisioningStatus = status
            return
        }

        resumeProvisioningStatusContinuation(with: .success(status))
    }
}

private extension BlePairingCentralManager {

    func describe(_ state: CBManagerState) -> String {
        switch state {
        case .unknown:
            "unknown"
        case .resetting:
            "resetting"
        case .unsupported:
            "unsupported"
        case .unauthorized:
            "unauthorized"
        case .poweredOff:
            "poweredOff"
        case .poweredOn:
            "poweredOn"
        @unknown default:
            "unknown-default"
        }
    }

    func upsert(_ device: DiscoveredBLEDevice) {
        if let index = discoveredDevices.firstIndex(where: { $0.id == device.id }) {
            discoveredDevices[index] = device
        } else {
            discoveredDevices.append(device)
            discoveredDevices.sort { $0.rssi > $1.rssi }
        }
    }

    func decodeProvisioningStatus(from data: Data?) -> PairingProvisioningStatus? {
        guard let data, data.isEmpty == false else {
            return nil
        }

        if let rawStatus = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased(),
           rawStatus.isEmpty == false {
            let normalizedStatus = rawStatus.replacingOccurrences(of: " ", with: "")
            let components = normalizedStatus
                .split(separator: ":")
                .map(String.init)

            let lastComponent = components.last ?? normalizedStatus

            switch lastComponent {
            case "1", "ok", "success", "completed", "complete", "true":
                return .completed
            case "0", "error", "failed", "failure", "false", "fail":
                if components.count > 2 {
                    let reason = components.dropFirst().joined(separator: ":")
                    return .failed(reason: reason)
                }
                return .failed(reason: "La configuration a ete refusee par le capteur.")
            case "sending", "sendingcredentials":
                return .sendingCredentials
            case "connecting", "connectingtonetwork":
                return .connectingToNetwork
            case "registering", "registeringtobackend":
                return .registeringToBackend
            default:
                switch normalizedStatus {
                case "wifi:ok":
                    return .completed
                case "wifi:fail", "wifi:error", "wifi:failed":
                    return .failed(reason: "La configuration Wi-Fi a echoue.")
                default:
                    return .failed(reason: rawStatus)
                }
            }
        }

        if let firstByte = data.first {
            return switch firstByte {
            case 1:
                .completed
            case 0:
                .failed(reason: "La configuration a ete refusee par le capteur.")
            default:
                .failed(reason: "Statut de configuration inconnu: \(firstByte)")
            }
        }

        return .failed(reason: "Impossible de lire le statut de configuration.")
    }

    func resumeProvisioningStatusContinuation(
        with result: Result<PairingProvisioningStatus, Error>
    ) {
        provisioningStatusTimeoutWorkItem?.cancel()
        provisioningStatusTimeoutWorkItem = nil

        guard let provisioningStatusContinuation else { return }
        self.provisioningStatusContinuation = nil

        switch result {
        case .success(let status):
            provisioningStatusContinuation.resume(returning: status)
        case .failure(let error):
            provisioningStatusContinuation.resume(throwing: error)
        }
    }
}

private extension BLEPairingConfiguration {

    static let `default` = Self(
        serviceUUIDs: [
            "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
        ],
        characteristics: .init(
            deviceInfo: "0000FFF1-0000-1000-8000-00805F9B34FB",
            wifiConfigurationWrite: "beb5483e-36e1-4688-b7f5-ea07361b26a8",
            provisioningStatus: "1439cab0-6639-4a51-afe1-488287674326"
        ),
        deviceNamePrefix: nil
    )
}

extension InjectedValues {

    @Inject var blePairingCentralManager: any BlePairingCentralManagerProtocol = BlePairingCentralManager()
}
