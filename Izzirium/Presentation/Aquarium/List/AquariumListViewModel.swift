//
//  AquariumListViewModel.swift
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
protocol AquariumListViewModelProtocol: ObservableObject {
    
    var dataListState: SKLoadingState<[AquariumUI]> { get }
    var dataFavoriteState: SKLoadingState<AquariumUI?> { get }
    
    func fetchAquariums() async
    func fetchFavorite() async
}

@InjectedMember(\.getAquariumsUseCase)
final class AquariumListViewModel: AquariumListViewModelProtocol {
    
    // MARK: - Error
    
    enum Error: Swift.Error, LocalizedError {
        
        case common
        case notLogged
        
        var errorDescription: String {
            switch self {
            case .common:
                "Une erreur est survenue. Veuillez réessayer."
            case .notLogged:
                "Vous devez être connecté pour faire cette action."
            }
        }
    }

    // MARK: - Properties
    
    @Published private(set) var dataListState: SKLoadingState<[AquariumUI]> = .loading
    @Published private(set) var dataFavoriteState: SKLoadingState<AquariumUI?> = .loading

    private let logger = Logger(category: AquariumListViewModel.self)

    // MARK: - AquariumListViewModelProtocol

    func fetchAquariums() async {
        logger.info("fetchAquariums")
        
        do {
            let aquariums = try await getAquariumsUseCase.perform()
            dataListState = .loaded(aquariums.map(AquariumUIAdapter.convert))
        } catch let error as DataError {
            switch error {
            case .decoding, .network:
                dataListState = .failed(Error.common)
            case .invalidCredentials:
                dataListState = .failed(Error.notLogged)
            }
        } catch {
            dataListState = .failed(error)
        }
    }
    
    func fetchFavorite() async {
        logger.info("fetchFavorite")
    }
}
