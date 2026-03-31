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
                name: "Mon Aquarium de salon"
            )
        }
        
        static var list: [AquariumDTO] {
            [
                AquariumDTO(
                    id: 0,
                    name: "Mon Aquarium de salon"
                ),
                AquariumDTO(
                    id: 1,
                    name: "Mon Aquarium de bureau"
                ),
                AquariumDTO(
                    id: 2,
                    name: "Mon Aquarium de garage"
                )
            ]
        }
    }
}

#endif
