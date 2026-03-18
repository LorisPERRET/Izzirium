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
    var favorite: Int? { get }
    var dataState: SKLoadingState<DataResponse> { get }
    var confirmFavoritePopup: Bool { get set }
    
    func getDatas() async
    func getValues(for type: SensorType, logs: [AquariumUI.LogUI]) -> [ChartValue]
    func setFavorite() async
    func confirmFavorite() async
}

@InjectedMember(\.getLogsUseCase)
@InjectedMember(\.getAlertUseCase)
@InjectedMember(\.getFavoriteAquariumUseCase)
@InjectedMember(\.setFavoriteAquariumUseCase)
final class AquariumViewModel: AquariumViewModelProtocol {

    // MARK: - Properties
    
    private(set) var aquarium: AquariumUI
    @Published private(set) var favorite: Int?
    @Published private(set) var dataState: SKLoadingState<DataResponse> = .loading
    @Published var confirmFavoritePopup = false

    private let logger = Logger(category: AquariumViewModel.self)
    
    // MARK: - Init

    init(aquarium: AquariumUI) {
        self.aquarium = aquarium
    }

    // MARK: - AquariumViewModelProtocol

    func getDatas() async {
        logger.info("getDatas")
        
        dataState = .loading
        
        do {
            logger.info("getLogs")
            let logs = try await getLogsUseCase.perform(aquarium: aquarium.id)
            
            logger.info("getAlert")
            let alert = try await getAlertUseCase.perform(aquarium: aquarium.id)
            
            logger.info("getFavorite")
            let aquarium = await getFavoriteAquariumUseCase.perform()
            favorite = aquarium?.modelId
            
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
    
    func setFavorite() async {
        logger.info("setFavorite")
        
        if let favorite {
            if favorite == aquarium.id {
                logger.info("already favorite")
                
                await setFavoriteAquariumUseCase.perform(aquarium: nil)
                self.favorite = nil
            } else {
                logger.info("other favorite")
                
                confirmFavoritePopup = true
            }
        } else {
            logger.info("no favorite")
            
            await setFavoriteAquariumUseCase.perform(aquarium: aquarium.id)
            favorite = aquarium.id
        }
    }
    
    func confirmFavorite() async {
        logger.info("confirmFavorite")
        
        await setFavoriteAquariumUseCase.perform(aquarium: aquarium.id)
        favorite = aquarium.id
    }
}
