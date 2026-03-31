//
//  AlertRequestDTO.swift
//  Data
//
//  Created by Loris Perret on 23/03/2026.
//

public struct AlertRequestDTO: Codable, Sendable, Equatable {
    
    let aquariumId: Int
    
    let phMin: Float?
    let phMax: Float?
    
    let tdsMin: Float?
    let tdsMax: Float?
    
    let turbidityMin: Float?
    let turbidityMax: Float?
    
    let temperatureMin: Float?
    let temperatureMax: Float?
    
    public init(
        aquariumId: Int,
        phMin: Float?,
        phMax: Float?,
        tdsMin: Float?,
        tdsMax: Float?,
        turbidityMin: Float?,
        turbidityMax: Float?,
        temperatureMin: Float?,
        temperatureMax: Float?
    ) {
        self.aquariumId = aquariumId
        self.phMin = phMin
        self.phMax = phMax
        self.tdsMin = tdsMin
        self.tdsMax = tdsMax
        self.turbidityMin = turbidityMin
        self.turbidityMax = turbidityMax
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
    }
}
