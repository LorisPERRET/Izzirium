//
//  FakeAquariumViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

#if DEBUG

import Foundation
import SKState

final class FakeAquariumViewModel: AquariumViewModelProtocol {

    // MARK: - Properties
    
    private(set) var aquarium: AquariumUI
    private(set) var favorite: Int?
    private(set) var dataState: SKState.SKLoadingState<DataResponse>
    @Published var confirmFavoritePopup = false
    
    // MARK: - Init
    
    init(withState dataState: SKLoadingState<DataResponse>, aquarium: AquariumUI, favorite: Int?) {
        self.dataState = dataState
        self.aquarium = aquarium
        self.favorite = favorite
    }

    // MARK: - AquariumViewModelProtocol
    
    func getDatas() async {}
    func getValues(for type: SensorType, logs: [AquariumUI.LogUI]) -> [ChartValue] {
        return logs.getValues(for: type).map {
            ChartValue(date: $0.date, value: $0.value)
        }
    }
    
    func setFavorite() async {
        if let favorite {
            if favorite == aquarium.id {
                self.favorite = aquarium.id
            } else {
                confirmFavoritePopup = true
            }
        } else {
            favorite = aquarium.id
        }
    }
    
    func confirmFavorite() async {
        favorite = aquarium.id
    }
}

#endif
