//
//  AlertDTO.swift
//  Data
//
//  Created by Loris Perret on 17/03/2026.
//

import Foundation

struct AlertDTO: Codable, Sendable, Equatable {
    
    let id: Int
    let aquariumId: Int
    
    let phMin: Float
    let phMax: Float
    
    let tdsMin: Float
    let tdsMax: Float
    
    let turbidityMin: Float
    let turbidityMax: Float
    
    let temperatureMin: Float
    let temperatureMax: Float
}
