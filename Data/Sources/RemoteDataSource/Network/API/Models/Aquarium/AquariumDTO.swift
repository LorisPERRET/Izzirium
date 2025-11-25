//
//  AquariumDTO.swift
//  Data
//
//  Created by Loris Perret on 25/07/2025.
//

import Foundation

public struct AquariumDTO: Codable, Sendable, Equatable {
    
    var id: Int
    var name: String
    var logs: [LogDTO]
    
    init(id: Int, name: String, logs: [LogDTO]) {
        self.id = id
        self.name = name
        self.logs = logs
    }
}
