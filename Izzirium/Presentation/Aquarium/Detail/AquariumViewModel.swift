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

@MainActor
protocol AquariumViewModelProtocol: ObservableObject {
    
    var aquarium: AquariumUI { get }
    var dataState: SKLoadingState<[AquariumUI.LogUI]> { get }
    
    func getLogs() async
    func getValues(for type: LogType, logs: [AquariumUI.LogUI]) -> [ChartValue]
}

@InjectedMember(\.getLogsUseCase)
final class AquariumViewModel: AquariumViewModelProtocol {

    // MARK: - Error

    enum Error: Swift.Error {
        
        case common
        case notLogged
    }

    // MARK: - Properties
    
    private(set) var aquarium: AquariumUI
    @Published private(set) var dataState: SKLoadingState<[AquariumUI.LogUI]> = .loading

    private let logger = Logger(category: AquariumViewModel.self)
    
    // MARK: - Init

    init(aquarium: AquariumUI) {
        self.aquarium = aquarium
    }

    // MARK: - AquariumViewModelProtocol

    func getLogs() async {
        logger.info("getLogs")
        
        do {            
            let logs = try await getLogsUseCase.perform(aquarium: aquarium.id)
            dataState = .loaded(logs.map(LogUIAdapter.convert))
        } catch let error as DataError {
            switch error {
            case .decoding, .network:
                dataState = .failed(Error.common)
            case .invalidCredentials:
                dataState = .failed(Error.notLogged)
            }
        } catch {
            dataState = .failed(error)
        }
    }
    
    func getValues(for type: LogType, logs: [AquariumUI.LogUI]) -> [ChartValue] {
        logger.info("getValues")
        
        let values: [ChartValue]
        switch type {
        case .ph:
            values = logs.map { ChartValue(date: $0.date, value: $0.ph) }
        case .tds:
            values = logs.map { ChartValue(date: $0.date, value: $0.tds) }
        case .turbidity:
            values = logs.map { ChartValue(date: $0.date, value: $0.turbidity) }
        case .temperature:
            values = logs.map { ChartValue(date: $0.date, value: $0.temperature) }
        }
        return values
    }
}
