//
//  AquariumUI.swift
//  Izzirium
//
//  Created by Loris Perret on 13/11/2025.
//

import Foundation

struct AquariumUI: Identifiable {
    
    struct LogUI {
        
        var date: Date
        
        var ph: Float
        var tds: Float
        var turbidity: Float
        var temperature: Float
    }
    
    var id: Int
    var name: String
    var logs: [LogUI]
}

extension [AquariumUI.LogUI] {
    
    func getValues(for type: SensorType) -> [(date: Date, value: Float)] {
        switch type {
        case .ph:
            return self.map { ($0.date, $0.ph) }
        case .tds:
            return self.map { ($0.date, $0.tds) }
        case .turbidity:
            return self.map { ($0.date, $0.turbidity) }
        case .temperature:
            return self.map { ($0.date, $0.temperature) }
        }
    }
}
