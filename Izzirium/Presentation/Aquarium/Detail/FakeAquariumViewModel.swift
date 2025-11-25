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
    private(set) var dataState: SKLoadingState<[AquariumUI.LogUI]>
    
    // MARK: - Init
    
    init(withState dataState: SKLoadingState<[AquariumUI.LogUI]>, aquarium: AquariumUI) {
        self.dataState = dataState
        self.aquarium = aquarium
    }

    // MARK: - AquariumViewModelProtocol
    
    func getLogs() async {}
    func getValues(for type: LogType, logs: [AquariumUI.LogUI]) -> [ChartValue] {
        let values: [ChartValue]
        switch type {
        case .ph:
            values = logs.map { ChartValue(date: $0.date, value: $0.ph) }
        case .tds:
            values = logs.map { ChartValue(date: $0.date, value: $0.tds) }
        case .turbidity:
            values = logs.map { ChartValue(date: $0.date, value: $0.turbidity) }
        case .temperature:
            values = logs.map { ChartValue(date: $0.date, value: $0.temperature) }
        }
        return values
    }
}

#endif
