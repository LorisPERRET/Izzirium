//
//  AquariumDTO+Fake.swift
//  Data
//
//  Created by Loris Perret on 25/07/2025.
//

#if DEBUG

import Foundation

extension AquariumDTO {

    enum Fake {
        
        static var aquarium: AquariumDTO {
            AquariumDTO(
                id: 0,
                name: "Mon Aquarium de salon",
                secretSensorId: "id"
            )
        }
        
        static var list: [AquariumDTO] {
            [
                AquariumDTO(
                    id: 0,
                    name: "Mon Aquarium de salon",
                    secretSensorId: "id"
                ),
                AquariumDTO(
                    id: 1,
                    name: "Mon Aquarium de bureau",
                    secretSensorId: "id"
                ),
                AquariumDTO(
                    id: 2,
                    name: "Mon Aquarium de garage",
                    secretSensorId: "id"
                )
            ]
        }
    }
}

#endif
