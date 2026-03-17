//
//  AlertDTO+Fake.swift
//  Data
//
//  Created by Loris Perret on 17/03/2026.
//

#if DEBUG

import Foundation

extension AlertDTO {
    
    public enum Fake {
        
        static var preview: AlertDTO {
            AlertDTO(
                id: 0,
                aquariumId: 0,
                phMin: 6.5,
                phMax: 7.5,
                tdsMin: 200,
                tdsMax: 400,
                turbidityMin: 0,
                turbidityMax: 5,
                temperatureMin: 22,
                temperatureMax: 26
            )
        }
    }
}

#endif
