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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
