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
    var deleteRequestState: SKDataRequestState<Void> { get }
    var deleteRequestStatePublisher: SKDataRequestStatePublisher<Void> { get }
    
    func fetchAquariums() async
    func fetchFavorite() async
    func deleteAquarium(id: Int) async
}

@InjectedMember(\.getAquariumsUseCase)
@InjectedMember(\.deleteAquariumUseCase)
@InjectedMember(\.getFavoriteAquariumUseCase)
final class AquariumListViewModel: AquariumListViewModelProtocol {
    
    // MARK: - Properties
    
    @Published private(set) var dataListState: SKLoadingState<[AquariumUI]> = .loading
    @Published private(set) var dataFavoriteState: SKLoadingState<AquariumUI?> = .loading
    @Published private(set) var deleteRequestState: SKDataRequestState<Void> = .idle
    var deleteRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $deleteRequestState
    }

    private let logger = Logger(category: AquariumListViewModel.self)

    // MARK: - AquariumListViewModelProtocol

    func fetchAquariums() async {
        logger.info("fetchAquariums")
        
        dataListState = .loading
        
        do {
            let aquariums = try await getAquariumsUseCase.perform()
            dataListState = .loaded(aquariums.map(AquariumUIAdapter.convert))
        } catch {
            dataListState = .failed(error)
        }
    }
    
    func fetchFavorite() async {
        logger.info("fetchFavorite")
        
        dataFavoriteState = .loading
        
        let aquarium = await getFavoriteAquariumUseCase.perform()
        dataFavoriteState = .loaded(aquarium.map(AquariumUIAdapter.convert))
    }
    
    func deleteAquarium(id: Int) async {
        logger.info("deleteAquarium")
        
        deleteRequestState = .loading
        
        do {
            try await deleteAquariumUseCase.perform(id: id)
            deleteRequestState = .success(())
        } catch {
            deleteRequestState = .error(error)
        }
    }
}
