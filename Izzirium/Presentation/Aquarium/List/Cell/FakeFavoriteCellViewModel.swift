//
//  FakeFavoriteCellViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

#if DEBUG

import Foundation
import SKState

final class FakeFavoriteCellViewModel: FavoriteCellViewModelProtocol {

    // MARK: - Properties
    
    private(set) var aquarium: AquariumUI
    private(set) var dataState: SKLoadingState<[AquariumUI.LogUI]>
    
    // MARK: - Init
    
    init(withState dataState: SKLoadingState<[AquariumUI.LogUI]>, aquarium: AquariumUI) {
        self.dataState = dataState
        self.aquarium = aquarium
    }

    // MARK: - FavoriteCellViewModelProtocol
    
    func getLogs() async {}
}

#endif
