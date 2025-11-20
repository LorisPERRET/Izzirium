//
//  AquariumUI+Fake.swift
//  Izzirium
//
//  Created by Loris Perret on 13/11/2025.
//

#if DEBUG

import Foundation

extension AquariumUI {
    
    enum Fake {
        
        static var preview: AquariumUI {
            AquariumUI(
                id: 0,
                name: "Mon Aquarium de salon",
                logs: [
                    AquariumUI.LogUI(
                        date: Date(),
                        ph: 10,
                        tds: 10,
                        turbidity: 10,
                        temperature: 10
                    )
                ]
            )
        }
        
        static var list: [AquariumUI] {
            [
                AquariumUI(
                    id: 0,
                    name: "Mon Aquarium de salon",
                    logs: [
                        AquariumUI.LogUI(
                            date: Date(),
                            ph: 7.2,
                            tds: 220,
                            turbidity: 2.0,
                            temperature: 25.5
                        ),
                        AquariumUI.LogUI(
                            date: Date().advanced(by: 3_600),
                            ph: 7.1,
                            tds: 215,
                            turbidity: 1.8,
                            temperature: 25.7
                        ),
                        AquariumUI.LogUI(
                            date: Date().advanced(by: 7_200),
                            ph: 7.15,
                            tds: 225,
                            turbidity: 2.2,
                            temperature: 25.4
                        ),
                        AquariumUI.LogUI(
                            date: Date().advanced(by: 10_800),
                            ph: 7.05,
                            tds: 230,
                            turbidity: 2.5,
                            temperature: 25.6
                        )
                    ]
                ),
                AquariumUI(
                    id: 1,
                    name: "Mon Aquarium de bureau",
                    logs: [
                        AquariumUI.LogUI(
                            date: Date(),
                            ph: 10,
                            tds: 10,
                            turbidity: 10,
                            temperature: 10
                        )
                    ]
                ),
                AquariumUI(
                    id: 2,
                    name: "Mon Aquarium de garage",
                    logs: [
                        AquariumUI.LogUI(
                            date: Date(),
                            ph: 10,
                            tds: 10,
                            turbidity: 10,
                            temperature: 10
                        )
                    ]
                )
            ]
        }
    }
}

#endif
