//
//  AlertUIAdapter.swift
//  Izzirium
//
//  Created by Loris Perret on 24/11/2025.
//

import Domain

enum AlertUIAdapter {

    // MARK: Typealias

    public typealias Input = Alert
    public typealias Output = AquariumUI.AlertUI

    // MARK: Adapter

    public static func convert(from object: Input) -> Output {
        Output(
            phMin: object.phMin,
            phMax: object.phMax,
            tdsMin: object.tdsMin,
            tdsMax: object.tdsMax,
            turbidityMin: object.turbidityMin,
            turbidityMax: object.turbidityMax,
            temperatureMin: object.temperatureMin,
            temperatureMax: object.temperatureMax
        )
    }
}
