//
//  FavoriteCellViewModel.swift
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
protocol FavoriteCellViewModelProtocol: ObservableObject {
    
    var aquarium: AquariumUI { get }
    var dataState: SKLoadingState<[AquariumUI.LogUI]> { get }
    
    func getLogs() async
}

@InjectedMember(\.getLogsUseCase)
final class FavoriteCellViewModel: FavoriteCellViewModelProtocol {

    // MARK: - Properties
    
    private(set) var aquarium: AquariumUI
    @Published private(set) var dataState: SKLoadingState<[AquariumUI.LogUI]> = .loading

    private let logger = Logger(category: FavoriteCellViewModel.self)
    
    // MARK: - Init

    init(aquarium: AquariumUI) {
        self.aquarium = aquarium
    }

    // MARK: - FavoriteCellViewModelProtocol

    func getLogs() async {
        logger.info("getLogs")
        
        dataState = .loading
        
        do {            
            let logs = try await getLogsUseCase.perform(aquarium: aquarium.id)
            dataState = .loaded(logs.map(LogUIAdapter.convert))
        } catch {
            dataState = .failed(error)
        }
    }
}
