//
//  PairingManager.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
//

import Combine
import Data
import Foundation
import SKDependencyInjection

public protocol PairingManagerProtocol: ObservableObject {

    var pairingState: PairingState { get }
    var discoveredDevices: [DiscoveredBLEDevice] { get }
    var pairedDevices: [PairedBLEDevice] { get }
    var pairingStatePublisher: AnyPublisher<PairingState, Never> { get }
    var discoveredDevicesPublisher: AnyPublisher<[DiscoveredBLEDevice], Never> { get }

    func preparePairing()
    func startScanning() throws
    func stopScanning()
    func connect(to device: DiscoveredBLEDevice) async throws
    func sendProvisioning(_ credentials: PairingCredentials) async throws
    func reset()
}

@InjectedMember(\.blePairingCentralManager)
final class PairingManager: ObservableObject, PairingManagerProtocol, @unchecked Sendable {

    @Published public private(set) var pairingState: PairingState = .idle
    @Published public private(set) var discoveredDevices: [DiscoveredBLEDevice] = []
    @Published public private(set) var pairedDevices: [PairedBLEDevice] = []

    var pairingStatePublisher: AnyPublisher<PairingState, Never> {
        $pairingState.eraseToAnyPublisher()
    }

    var discoveredDevicesPublisher: AnyPublisher<[DiscoveredBLEDevice], Never> {
        $discoveredDevices.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()
    private var connectedIdentity: PairingDeviceIdentity?
    private let logger = Logger(category: PairingManager.self)

    init() {
        bindBLEState()
    }

    func preparePairing() {
        pairingState = .checkingPermissions
        logger.info("preparePairing with BLE state: \(String(describing: blePairingCentralManager.bluetoothState))")

        switch blePairingCentralManager.bluetoothState {
        case .poweredOn:
            pairingState = .idle
        case .unauthorized:
            pairingState = .failed(.bluetoothUnauthorized)
        case .poweredOff, .unsupported:
            pairingState = .bluetoothUnavailable
        case .unknown, .resetting:
            pairingState = .checkingPermissions
        }

        logger.info("preparePairing mapped to pairingState: \(String(describing: pairingState))")
    }

    func startScanning() throws {
        connectedIdentity = nil
        discoveredDevices = []
        logger.info("startScanning called with BLE state: \(String(describing: blePairingCentralManager.bluetoothState))")
        pairingState = .scanning
        try blePairingCentralManager.startScan()
        logger.info("BLE scan started")
    }

    func stopScanning() {
        blePairingCentralManager.stopScan()

        if discoveredDevices.isEmpty {
            pairingState = .idle
        } else {
            pairingState = .deviceFound(discoveredDevices)
        }
    }

    func connect(to device: DiscoveredBLEDevice) async throws {
        pairingState = .connecting(device)

        do {
            let identity = try await blePairingCentralManager.connect(to: device)
            connectedIdentity = identity
            pairingState = .deviceReady(identity)
        } catch let error as PairingError {
            pairingState = .failed(error)
            throw error
        } catch {
            let pairingError = PairingError.connectionFailed(reason: error.localizedDescription)
            pairingState = .failed(pairingError)
            throw pairingError
        }
    }

    func sendProvisioning(_ credentials: PairingCredentials) async throws {
        guard let connectedIdentity else {
            throw PairingError.deviceNotFound
        }

        pairingState = .provisioning(connectedIdentity)

        do {
            try await blePairingCentralManager.sendProvisioning(credentials)
            let status = try await blePairingCentralManager.readProvisioningStatus()

            if case .failed(let reason) = status {
                let error = PairingError.provisioningFailed(reason: reason)
                pairingState = .failed(error)
                throw error
            }
            
            pairingState = .success
        } catch let error as PairingError {
            pairingState = .failed(error)
            throw error
        } catch {
            let error = PairingError.provisioningFailed(reason: error.localizedDescription)
            pairingState = .failed(error)
            throw error
        }
    }

    func reset() {
        blePairingCentralManager.stopScan()
        blePairingCentralManager.disconnectCurrentDevice()
        connectedIdentity = nil
        discoveredDevices = []
        pairingState = .idle
    }
}

private extension PairingManager {

    func bindBLEState() {
        blePairingCentralManager.discoveredDevicesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (devices: [DiscoveredBLEDevice]) in
                guard let self else { return }

                discoveredDevices = devices

                if case .scanning = pairingState, devices.isEmpty == false {
                    pairingState = .deviceFound(devices)
                } else if case .deviceFound = pairingState {
                    pairingState = .deviceFound(devices)
                }
            }
            .store(in: &cancellables)

        blePairingCentralManager.bluetoothStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state: BLEBluetoothState) in
                guard let self else { return }

                switch state {
                case .poweredOn:
                    if pairingState == .bluetoothUnavailable || pairingState == .checkingPermissions {
                        pairingState = .idle
                    }
                case .unauthorized:
                    pairingState = .failed(.bluetoothUnauthorized)
                case .poweredOff, .unsupported:
                    if case .success = pairingState {
                        return
                    }
                    pairingState = .bluetoothUnavailable
                case .unknown, .resetting:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension InjectedValues {

    @Inject public var pairingManager: PairingManagerProtocol = PairingManager()
}
