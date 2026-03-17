//
//  AlertAdapter.swift
//  Data
//
//  Created by Loris Perret on 28/10/2025.
//

enum AlertAdapter {

    // MARK: Typealias

    typealias Input = AlertDTO
    typealias Output = AlertData

    // MARK: Adapter

    static func convert(from object: Input) -> Output {
        Output(
            modelId: object.id,
            aquariumId: object.aquariumId,
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
