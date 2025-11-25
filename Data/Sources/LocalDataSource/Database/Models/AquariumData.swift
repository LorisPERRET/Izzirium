//
//  AquariumData.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SwiftData

@Model
public final class AquariumData: ModelIdentifiable {
    
    // MARK: - Properties
    
    @Attribute(.unique) public var modelId: Int
    public var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \LogData.aquarium)
    public var logs: [LogData]
    
    // MARK: - Init
    
    public init(modelId: Int, name: String, logs: [LogData]) {
        self.modelId = modelId
        self.name = name
        self.logs = logs
    }
}
