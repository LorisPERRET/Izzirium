//
//  SensorType.swift
//  Izzirium
//
//  Created by Loris Perret on 24/11/2025.
//

enum SensorType: CaseIterable {

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

    var unitLabel: String? {
        switch self {
        case .ph:
            nil
        case .tds:
            "ppm"
        case .turbidity:
            "NTU"
        case .temperature:
            "°C"
        }
    }
}
