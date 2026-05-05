//
//  FakeAquariumListViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

#if DEBUG

import Foundation
import SKState

final class FakeAquariumListViewModel: AquariumListViewModelProtocol {

    // MARK: - Properties
    
    @Published private(set) var dataListState: SKLoadingState<[AquariumUI]>
    @Published private(set) var dataFavoriteState: SKLoadingState<AquariumUI?>
    @Published private(set) var deleteRequestState: SKDataRequestState<Void> = .idle
    var deleteRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $deleteRequestState
    }

    // MARK: - Init
    
    init(
        withListState dataListState: SKLoadingState<[AquariumUI]>,
        withFavoriteState dataFavoriteState: SKLoadingState<AquariumUI?>
    ) {
        self.dataListState = dataListState
        self.dataFavoriteState = dataFavoriteState
    }

    // MARK: - AquariumListViewModelProtocol

    func fetchAquariums() {}
    func fetchFavorite() {}
    func deleteAquarium(id: Int) async {}
}

#endif
