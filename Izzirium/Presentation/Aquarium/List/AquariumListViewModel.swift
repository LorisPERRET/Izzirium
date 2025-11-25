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
    
    var dataState: SKLoadingState<[AquariumUI]> { get }
    
    func fetchAquariums() async
}

@InjectedMember(\.getAquariumsUseCase)
final class AquariumListViewModel: AquariumListViewModelProtocol {
    
    // MARK: - Error
    
    enum Error: Swift.Error {
        
        case common
        case notLogged
    }

    // MARK: - Properties
    
    @Published private(set) var dataState: SKLoadingState<[AquariumUI]> = .loading

    private let logger = Logger(category: AquariumListViewModel.self)

    // MARK: - AquariumListViewModelProtocol

    func fetchAquariums() async {
        logger.info("fetchAquariums")
        
        do {
            let aquariums = try await getAquariumsUseCase.perform()
            dataState = .loaded(aquariums.map(AquariumUIAdapter.convert))
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
}
