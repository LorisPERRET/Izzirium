//
//  LogUIAdapter.swift
//  Izzirium
//
//  Created by Loris Perret on 24/11/2025.
//

import Domain

enum LogUIAdapter {

    // MARK: Typealias

    public typealias Input = Log
    public typealias Output = AquariumUI.LogUI

    // MARK: Adapter

    public static func convert(from object: Input) -> Output {
        Output(
            date: object.date,
            ph: object.ph,
            tds: object.tds,
            turbidity: object.turbidity,
            temperature: object.temperature
        )
    }
}
