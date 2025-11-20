//
//  AquariumViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Foundation
import SKDependencyInjection
import SKState

@MainActor
protocol AquariumViewModelProtocol: ObservableObject {
    
    var aquarium: AquariumUI { get }
    
    func getMesures(for type: AquariumViewModel.LogType) -> [SensorView.ChartValue]
}

final class AquariumViewModel: AquariumViewModelProtocol {

    // MARK: - Properties
    
    enum LogType {
        
        case ph, tds, turbidity, temperature
        
        var title: String {
            switch self {
            case .ph:
                "PH"
            case .tds:
                "TDS"
            case .turbidity:
                "Turbidité"
            case .temperature:
                "Température"
            }
        }
    }
    
    private(set) var aquarium: AquariumUI
//    private let logger = Logger(category: AquariumViewModel.self)
    
    // MARK: - Init

    init(aquarium: AquariumUI) {
        self.aquarium = aquarium
    }

    // MARK: - AquariumViewModelProtocol

    func getMesures(for type: AquariumViewModel.LogType) -> [SensorView.ChartValue] {
        switch type {
        case .ph:
            return aquarium.logs.map { SensorView.ChartValue(date: $0.date, value: $0.ph) }
        case .tds:
            return aquarium.logs.map { SensorView.ChartValue(date: $0.date, value: $0.tds) }
        case .turbidity:
            return aquarium.logs.map { SensorView.ChartValue(date: $0.date, value: $0.turbidity) }
        case .temperature:
            return aquarium.logs.map { SensorView.ChartValue(date: $0.date, value: $0.temperature) }
        }
    }
}
