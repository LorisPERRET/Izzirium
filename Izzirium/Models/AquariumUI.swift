//
//  AquariumUI.swift
//  Izzirium
//
//  Created by Loris Perret on 13/11/2025.
//

import Foundation

struct AquariumUI: Identifiable {
    
    struct LogUI {
        
        var date: Date
        
        var ph: Float
        var tds: Float
        var turbidity: Float
        var temperature: Float
    }
    
    var id: Int
    var name: String
    var logs: [LogUI]
}
