//
//  LogType.swift
//  Izzirium
//
//  Created by Loris Perret on 24/11/2025.
//


enum LogType {
        
    case ph, tds, turbidity, temperature
    
    var title: String {
        switch self {
        case .ph:
            "PH"
        case .tds:
            "TDS"
        case .turbidity:
            "Turbidité"
        case .temperature:
            "Température"
        }
    }
}
