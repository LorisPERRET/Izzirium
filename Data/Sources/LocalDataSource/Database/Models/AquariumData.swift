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
    
    @Relationship(deleteRule: .cascade, inverse: \AlertData.aquarium)
    public var alert: AlertData?
    
    // MARK: - Init
    
    public init(modelId: Int, name: String, logs: [LogData], alert: AlertData?) {
        self.modelId = modelId
        self.name = name
        self.logs = logs
        self.alert = alert
    }
}
