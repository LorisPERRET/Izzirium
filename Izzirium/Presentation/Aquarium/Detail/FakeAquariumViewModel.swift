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
    
    private(set) var aquarium: AquariumUI = AquariumUI.Fake.preview
    
    // MARK: - Init

    // MARK: - AquariumViewModelProtocol
    
    func getMesures(for type: AquariumViewModel.LogType) -> [SensorView.ChartValue] {
        [
            SensorView.ChartValue(date: Date(), value: 0),
            SensorView.ChartValue(date: Date().addingTimeInterval(100), value: 1),
            SensorView.ChartValue(date: Date().addingTimeInterval(300), value: 2)
        ]
    }
}

#endif
