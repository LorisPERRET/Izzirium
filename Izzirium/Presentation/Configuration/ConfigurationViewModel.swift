//
//  ConfigurationViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 24/03/2026.
//

import Domain
import Combine
import Foundation
import NetworkExtension
import SKDependencyInjection

@MainActor
protocol ConfigurationViewModelProtocol: ObservableObject {

    var pairingState: PairingState { get }
    var discoveredDevices: [DiscoveredBLEDevice] { get }
    var connectedDevice: PairingDeviceIdentity? { get }
    var errorMessage: String? { get }
    var wifiSSID: String { get set }
    var wifiPassword: String { get set }
    var sensorId: String { get set }

    func startScan()
    func connect(to device: DiscoveredBLEDevice)
}

@InjectedMember(\.pairingManager)
@MainActor
final class ConfigurationViewModel: ConfigurationViewModelProtocol {

    // MARK: - Properties

    @Published private(set) var pairingState: PairingState = .idle
    @Published private(set) var discoveredDevices: [DiscoveredBLEDevice] = []
    @Published private(set) var connectedDevice: PairingDeviceIdentity?
    @Published private(set) var errorMessage: String?
    @Published var wifiSSID = ""
    @Published var wifiPassword = ""
    @Published var sensorId = ""

    private let logger = Logger(category: ConfigurationViewModel.self)
    private var cancellables = Set<AnyCancellable>()

    init() {
        bindPairingManager()
        fetchCurrentSSID()
    }

    // MARK: - ConfigurationViewModelProtocol

    func startScan()  {
        logger.info("startScan")
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }

            pairingManager.preparePairing()

            do {
                try await waitUntilBluetoothIsReady()
                try pairingManager.startScanning()
            } catch {
                errorMessage = error.localizedDescription
                logger.error(error.localizedDescription)
            }
        }
    }

    func connect(to device: DiscoveredBLEDevice) {
        logger.info("connect to \(device.id)")
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }

            do {
                try await pairingManager.connect(to: device)
                let credentials = PairingCredentials(
                    wifiSSID: wifiSSID,
                    wifiPassword: wifiPassword,
                    sensorId: sensorId
                )
                _ = try await pairingManager.sendProvisioning(credentials)
            } catch {
                errorMessage = error.localizedDescription
                logger.error(error.localizedDescription)
            }
        }
    }
}

private extension ConfigurationViewModel {

    func bindPairingManager() {
        pairingState = pairingManager.pairingState
        discoveredDevices = pairingManager.discoveredDevices

        pairingManager.pairingStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                pairingState = state

                if case .deviceReady(let device) = state {
                    connectedDevice = device
                } else {
                    connectedDevice = nil
                }

                if case .failed(let error) = state {
                    errorMessage = error.localizedDescription
                }
            }
            .store(in: &cancellables)

        pairingManager.discoveredDevicesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] devices in
                guard let self else { return }
                discoveredDevices = devices
            }
            .store(in: &cancellables)
    }

    func fetchCurrentSSID() {
        NEHotspotNetwork.fetchCurrent { [weak self] network in
            guard let self, let ssid = network?.ssid, ssid.isEmpty == false else { return }

            Task { @MainActor in
                if self.wifiSSID.isEmpty {
                    self.wifiSSID = ssid
                    self.logger.info("Fetched current SSID: \(ssid)")
                }
            }
        }
    }

    func waitUntilBluetoothIsReady() async throws {
        let maxAttempts = 10

        for _ in 0..<maxAttempts {
            switch pairingManager.pairingState {
            case .idle:
                return
            case .failed(let error):
                throw error
            case .bluetoothUnavailable:
                throw PairingError.bluetoothUnavailable
            case .checkingPermissions:
                try await Task.sleep(for: .milliseconds(300))
            default:
                try await Task.sleep(for: .milliseconds(150))
            }
        }

        throw PairingError.timeout
    }
}
