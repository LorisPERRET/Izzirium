//
//  LogDTO.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation

struct LogDTO: Codable, Sendable, Equatable {
    
    var date: Date
    
    var ph: Float
    var tds: Float
    var turbidity: Float
    var temperature: Float
    
    init(date: Date, ph: Float, tds: Float, turbidity: Float, temperature: Float) {
        self.date = date
        self.ph = ph
        self.tds = tds
        self.turbidity = turbidity
        self.temperature = temperature
    }
}
