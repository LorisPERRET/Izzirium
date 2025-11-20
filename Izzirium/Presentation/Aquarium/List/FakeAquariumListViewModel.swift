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
    
    @Published private(set) var dataState: SKLoadingState<[AquariumUI]>

    // MARK: - Init
    
    init(withState dataState: SKLoadingState<[AquariumUI]>) {
        self.dataState = dataState
    }

    // MARK: - AquariumListViewModelProtocol

    func fetchAquariums() {}
}

#endif
