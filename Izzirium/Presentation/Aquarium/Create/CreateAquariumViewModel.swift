//
//  CreateAquariumViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Domain
import Foundation
import Kastor
import SKDependencyInjection
import SKState
import CoreLocation

@MainActor
protocol CreateAquariumViewModelProtocol: ObservableObject {

    var aquariumName: String { get set }

    var requestState: SKDataRequestState<String> { get }
    var requestStatePublisher: SKDataRequestStatePublisher<String> { get }
    
    var requestLocationState: SKDataRequestState<Void> { get }
    var requestLocationStatePublisher: SKDataRequestStatePublisher<Void> { get }

    func createAquarium() async
    func requestLocation()
}

@InjectedMember(\.createAquariumUseCase)
final class CreateAquariumViewModel: NSObject, CreateAquariumViewModelProtocol {

    // MARK: - Properties

    @Published var aquariumName: String = ""
    @Published private(set) var requestState: SKDataRequestState<String> = .idle
    var requestStatePublisher: SKDataRequestStatePublisher<String> {
        $requestState
    }
    @Published private(set) var requestLocationState: SKDataRequestState<Void> = .idle
    var requestLocationStatePublisher: SKDataRequestStatePublisher<Void> {
        $requestLocationState
    }

    private let logger = Logger(category: CreateAquariumViewModel.self)
    
    private let locationManager = CLLocationManager()
    private var didRequestLocationAuthorization = false
    
    // MARK: - Init
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - CreateAquariumViewModelProtocol

    func createAquarium() async {
        do {
            requestState = .loading
            let created = try await createAquariumUseCase.perform(name: aquariumName)
            requestState = .success(created.secretSensorId)
        } catch {
            requestState = .error(error)
        }
    }
    
    func requestLocation() {
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
    }
    
    private func requestLocationAuthorization() {
        guard didRequestLocationAuthorization == false else { return }
        didRequestLocationAuthorization = true
        locationManager.requestWhenInUseAuthorization()
    }
}

extension CreateAquariumViewModel: CLLocationManagerDelegate {
    
    enum Error: Swift.Error, LocalizedError {
        
        case locationNeeded
        
        var errorDescription: String? {
            switch self {
            case .locationNeeded:
                return "La localisation est nécessaire pour récuper les informations du WiFi."
            }
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                break
            case .notDetermined:
                break
            case .denied, .restricted:
                requestLocationState = .error(Error.locationNeeded)
                logger.info("Location authorization denied, current SSID unavailable")
            @unknown default:
                break
            }
        }
    }
}
