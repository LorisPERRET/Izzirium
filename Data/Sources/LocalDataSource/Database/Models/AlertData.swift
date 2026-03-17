//
//  AlertData.swift
//  Data
//
//  Created by Loris Perret on 17/03/2026.
//

import Foundation
import SwiftData

@Model
public final class AlertData: ModelIdentifiable {
    
    // MARK: - Properties
    
    @Attribute(.unique) public var modelId: Int
    public var aquariumId: Int
    
    public var phMin: Float
    public var phMax: Float
    
    public var tdsMin: Float
    public var tdsMax: Float
    
    public var turbidityMin: Float
    public var turbidityMax: Float
    
    public var temperatureMin: Float
    public var temperatureMax: Float
    
    var aquarium: AquariumData?
    
    // MARK: - Init
    
    public init(
        modelId: Int,
        aquariumId: Int,
        phMin: Float,
        phMax: Float,
        tdsMin: Float,
        tdsMax: Float,
        turbidityMin: Float,
        turbidityMax: Float,
        temperatureMin: Float,
        temperatureMax: Float
    ) {
        self.modelId = modelId
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
