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
    private(set) var dataState: SKState.SKLoadingState<DataResponse>
    
    // MARK: - Init
    
    init(withState dataState: SKLoadingState<DataResponse>, aquarium: AquariumUI) {
        self.dataState = dataState
        self.aquarium = aquarium
    }

    // MARK: - AquariumViewModelProtocol
    
    func getDatas() async {}
    func getValues(for type: SensorType, logs: [AquariumUI.LogUI]) -> [ChartValue] {
        return logs.getValues(for: type).map {
            ChartValue(date: $0.date, value: $0.value)
        }
    }
}

#endif
