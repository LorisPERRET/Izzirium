//
//  AquariumViewModel.swift
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

struct DataResponse {
    
    var logs: [AquariumUI.LogUI]
    var alert: AquariumUI.AlertUI?
}

@MainActor
protocol AquariumViewModelProtocol: ObservableObject {
    
    var aquarium: AquariumUI { get }
    var dataState: SKLoadingState<DataResponse> { get }
    
    func getDatas() async
    func getValues(for type: SensorType, logs: [AquariumUI.LogUI]) -> [ChartValue]
}

@InjectedMember(\.getLogsUseCase)
@InjectedMember(\.getAlertUseCase)
final class AquariumViewModel: AquariumViewModelProtocol {

    // MARK: - Properties
    
    private(set) var aquarium: AquariumUI
    @Published private(set) var dataState: SKLoadingState<DataResponse> = .loading

    private let logger = Logger(category: AquariumViewModel.self)
    
    // MARK: - Init

    init(aquarium: AquariumUI) {
        self.aquarium = aquarium
    }

    // MARK: - AquariumViewModelProtocol

    func getDatas() async {
        logger.info("getDatas")
        
        do {
            logger.info("getLogs")
            let logs = try await getLogsUseCase.perform(aquarium: aquarium.id)
            
            logger.info("getAlert")
            let alert = try await getAlertUseCase.perform(aquarium: aquarium.id)
            
            dataState = .loaded(
                DataResponse(
                    logs: logs.map(LogUIAdapter.convert),
                    alert: alert.map(AlertUIAdapter.convert)
                )
            )
        } catch {
            dataState = .failed(error)
        }
    }
    
    func getValues(for type: SensorType, logs: [AquariumUI.LogUI]) -> [ChartValue] {
        logger.info("getValues")
        
        return logs.getValues(for: type).map {
            ChartValue(date: $0.date, value: $0.value)
        }
    }
}
