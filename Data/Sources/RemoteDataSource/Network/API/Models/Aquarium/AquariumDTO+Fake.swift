//
//  AquariumDTO+Fake.swift
//  Data
//
//  Created by Loris Perret on 25/07/2025.
//

#if DEBUG

import Foundation

extension AquariumDTO {

    public enum Fake {
        
        static var aquarium: AquariumDTO {
            AquariumDTO(
                id: 0,
                name: "Mon Aquarium de salon",
                logs: []
            )
        }
        
        static var list: [AquariumDTO] {
            [
                AquariumDTO(
                    id: 0,
                    name: "Mon Aquarium de salon",
                    logs: [
                        LogDTO(
                            id: 1,
                            date: Date(),
                            ph: 7.2,
                            tds: 220,
                            turbidity: 2.0,
                            temperature: 25.5
                        ),
                        LogDTO(
                            id: 2,
                            date: Date().advanced(by: 3_600),
                            ph: 7.1,
                            tds: 215,
                            turbidity: 1.8,
                            temperature: 25.7
                        ),
                        LogDTO(
                            id: 3,
                            date: Date().advanced(by: 7_200),
                            ph: 7.15,
                            tds: 225,
                            turbidity: 2.2,
                            temperature: 25.4
                        ),
                        LogDTO(
                            id: 4,
                            date: Date().advanced(by: 10_800),
                            ph: 7.05,
                            tds: 230,
                            turbidity: 2.5,
                            temperature: 25.6
                        )
                    ]
                ),
                AquariumDTO(
                    id: 1,
                    name: "Mon Aquarium de bureau",
                    logs: []
                ),
                AquariumDTO(
                    id: 2,
                    name: "Mon Aquarium de garage",
                    logs: []
                )
            ]
        }
    }
}

#endif
