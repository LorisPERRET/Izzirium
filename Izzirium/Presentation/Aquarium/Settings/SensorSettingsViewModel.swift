//
//  SensorSettingsViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Data
import Domain
import Foundation
import Kastor
import SKDependencyInjection
import SKState

@MainActor
protocol SensorSettingsViewModelProtocol: ObservableObject {
    
    var dataRequestState: SKDataRequestState<Void> { get }
    var dataRequestStatePublisher: SKDataRequestStatePublisher<Void> { get }
    var aquariumName: String { get set }
    var alert: AlertUI { get set }
    
    func saveChange() async
}

@InjectedMember(\.updateAlertUseCase)
final class SensorSettingsViewModel: SensorSettingsViewModelProtocol {
    
    // MARK: - Properties
    
    let aquariumId: Int
    @Published var aquariumName: String
    @Published var alert: AlertUI
    @Published private(set) var dataRequestState: SKDataRequestState<Void> = .idle
    var dataRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $dataRequestState
    }
    let onSuccess: () async -> Void
    
    private let logger = Logger(category: SensorSettingsViewModel.self)
    
    // MARK: - Init
    
    init(aquariumId: Int, aquariumName: String, alert: AlertUI?, onSuccess: @escaping () async -> Void) {
        self.aquariumId = aquariumId
        self.aquariumName = aquariumName
        self.alert = alert ?? .init()
        self.onSuccess = onSuccess
    }

    // MARK: - SensorSettingsViewModelProtocol
    
    func saveChange() async {
        logger.info("saveChange")
        do {
            dataRequestState = .loading
            try await updateAlertUseCase.perform(
                alert: AlertBody(
                    aquariumId: aquariumId,
                    phMin: alert.phMin,
                    phMax: alert.phMax,
                    tdsMin: alert.tdsMin,
                    tdsMax: alert.tdsMax,
                    turbidityMin: alert.turbidityMin,
                    turbidityMax: alert.turbidityMax,
                    temperatureMin: alert.temperatureMin,
                    temperatureMax: alert.temperatureMax
                )
            )
            await onSuccess()
            logger.info("saveChange success")
            dataRequestState = .success(())
        } catch {
            logger.info("saveChange error: \(error.localizedDescription)")
            dataRequestState = .error(error)
        }
    }
}
