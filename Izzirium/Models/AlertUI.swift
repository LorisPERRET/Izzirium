//
//  AlertUI.swift
//  Izzirium
//
//  Created by Loris Perret on 23/03/2026.
//

struct AlertUI {
    
    var phMin: Float?
    var phMax: Float?
    
    var tdsMin: Float?
    var tdsMax: Float?
    
    var turbidityMin: Float?
    var turbidityMax: Float?
    
    var temperatureMin: Float?
    var temperatureMax: Float?
    
    func getValue(for type: SensorType) -> (min: Float?, max: Float?) {
        switch type {
        case .ph:
            return (self.phMin, self.phMax)
        case .tds:
            return (self.tdsMin, self.tdsMax)
        case .turbidity:
            return (self.turbidityMin, self.turbidityMax)
        case .temperature:
            return (self.temperatureMin, self.temperatureMax)
        }
    }
    
    mutating func setValue(for type: SensorType,  values: (min: Float?, max: Float?)) {
        switch type {
        case .ph:
            phMin = values.min
            phMax = values.max
        case .tds:
            tdsMin = values.min
            tdsMax = values.max
        case .turbidity:
            turbidityMin = values.min
            turbidityMax = values.max
        case .temperature:
            temperatureMin = values.min
            temperatureMax = values.max
        }
    }
}
