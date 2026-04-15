//
//  ConfigurationViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 24/03/2026.
//

import Domain
import Combine
import CoreLocation
import Foundation
import NetworkExtension
import SKDependencyInjection
import SKState

@MainActor
protocol ConfigurationViewModelProtocol: ObservableObject {

    var pairingState: PairingState { get }
    var discoveredDevices: [DiscoveredBLEDevice] { get }
    var connectedDevice: PairingDeviceIdentity? { get }
    var wifiSSID: String { get set }
    var wifiPassword: String { get set }

    var bleRequestState: SKDataRequestState<Void> { get }
    var bleRequestStatePublisher: SKDataRequestStatePublisher<Void> { get }

    var connectRequestState: SKDataRequestState<Void> { get }
    var connectRequestStatePublisher: SKDataRequestStatePublisher<Void> { get }

    func startScan()
    func connect(to device: DiscoveredBLEDevice) async
}

@InjectedMember(\.pairingManager)
@MainActor
final class ConfigurationViewModel: NSObject, ConfigurationViewModelProtocol {

    // MARK: - Properties

    @Published private(set) var pairingState: PairingState = .idle
    @Published private(set) var discoveredDevices: [DiscoveredBLEDevice] = []
    @Published private(set) var connectedDevice: PairingDeviceIdentity?
    @Published var wifiSSID = ""
    @Published var wifiPassword = ""
    private let sensorId: String
    private let locationManager = CLLocationManager()
    private var didRequestLocationAuthorization = false

    @Published private(set) var bleRequestState: SKDataRequestState<Void> = .idle
    var bleRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $bleRequestState
    }
    @Published private(set) var connectRequestState: SKDataRequestState<Void> = .idle
    var connectRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $connectRequestState
    }

    private let logger = Logger(category: ConfigurationViewModel.self)
    private var cancellables = Set<AnyCancellable>()

    init(sensorId: String) {
        self.sensorId = sensorId
        super.init()
        locationManager.delegate = self
        bindPairingManager()
        fetchCurrentSSID()
    }

    // MARK: - ConfigurationViewModelProtocol

    func startScan()  {
        logger.info("startScan")
        bleRequestState = .loading

        Task { [weak self] in
            guard let self else { return }

            pairingManager.preparePairing()

            do {
                try await waitUntilBluetoothIsReady()
                try pairingManager.startScanning()
                bleRequestState = .success(())
            } catch {
                bleRequestState = .error(error)
                logger.error(error.localizedDescription)
            }
        }
    }

    func connect(to device: DiscoveredBLEDevice) async {
        logger.info("connect to \(device.id)")
        connectRequestState = .loading

        do {
            try await pairingManager.connect(to: device)
            let credentials = PairingCredentials(
                wifiSSID: wifiSSID,
                wifiPassword: wifiPassword,
                sensorId: sensorId
            )
            _ = try await pairingManager.sendProvisioning(credentials)
            connectRequestState = .success(())
        } catch {
            connectRequestState = .error(error)
            logger.error(error.localizedDescription)
        }
    }

    private func bindPairingManager() {
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
                    bleRequestState = .error(error)
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

    private func fetchCurrentSSID() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined:
            requestLocationAuthorization()
            return
        case .denied, .restricted:
            logger.info("Location authorization unavailable, cannot fetch current SSID")
            return
        @unknown default:
            return
        }

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

    private func waitUntilBluetoothIsReady() async throws {
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

    private func requestLocationAuthorization() {
        guard didRequestLocationAuthorization == false else { return }
        didRequestLocationAuthorization = true
        locationManager.requestWhenInUseAuthorization()
    }
}

extension ConfigurationViewModel: CLLocationManagerDelegate {

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                fetchCurrentSSID()
            case .notDetermined:
                break
            case .denied, .restricted:
                logger.info("Location authorization denied, current SSID unavailable")
            @unknown default:
                break
            }
        }
    }
}
