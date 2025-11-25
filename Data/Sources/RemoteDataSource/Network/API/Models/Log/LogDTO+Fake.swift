//
//  LogDTO+Fakeswift
//  Data
//
//  Created by Loris Perret on 25/07/2025.
//

#if DEBUG

import Foundation

extension LogDTO {

    public enum Fake {
        
        static var log: LogDTO {
            LogDTO(
                date: Date(),
                ph: 20,
                tds: 20,
                turbidity: 20,
                temperature: 20
            )
        }
        
        static var list: [LogDTO] {
            [
                LogDTO(
                    date: Date(),
                    ph: 7.2,
                    tds: 220,
                    turbidity: 2.0,
                    temperature: 25.5
                ),
                LogDTO(
                    date: Date().advanced(by: 3_600),
                    ph: 7.1,
                    tds: 215,
                    turbidity: 1.8,
                    temperature: 25.7
                ),
                LogDTO(
                    date: Date().advanced(by: 7_200),
                    ph: 7.15,
                    tds: 225,
                    turbidity: 2.2,
                    temperature: 25.4
                ),
                LogDTO(
                    date: Date().advanced(by: 10_800),
                    ph: 7.05,
                    tds: 230,
                    turbidity: 2.5,
                    temperature: 25.6
                )
            ]
        }
    }
}

#endif
