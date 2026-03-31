//
//  LogDTO.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation

struct LogDTO: Codable, Sendable, Equatable {
    
    let id: Int
    let date: Date
    
    let ph: Float
    let tds: Float
    let turbidity: Float
    let temperature: Float
}
