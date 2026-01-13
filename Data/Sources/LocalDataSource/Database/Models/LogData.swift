//
//  LogData.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SwiftData

@Model
public final class LogData: ModelIdentifiable {
    
    // MARK: - Properties
    
    @Attribute(.unique) public var modelId: Int
    public var date: Date
    
    public var ph: Float
    public var tds: Float
    public var turbidity: Float
    public var temperature: Float
    
    var aquarium: AquariumData?
    
    // MARK: - Init
    
    public init(
        id: Int,
        date: Date,
        ph: Float,
        tds: Float,
        turbidity: Float,
        temperature: Float
    ) {
        self.modelId = id
        self.date = date
        self.ph = ph
        self.tds = tds
        self.turbidity = turbidity
        self.temperature = temperature
    }
}
