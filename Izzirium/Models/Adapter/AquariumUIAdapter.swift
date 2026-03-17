//
//  AquariumUIAdapter.swift
//  Izzirium
//
//  Created by Loris Perret on 24/11/2025.
//

import Domain

enum AquariumUIAdapter {

    // MARK: Typealias

    public typealias Input = Aquarium
    public typealias Output = AquariumUI

    // MARK: Adapter

    public static func convert(from object: Input) -> Output {
        Output(
            id: object.modelId,
            name: object.name,
            logs: object.logs.map(LogUIAdapter.convert),
            alert: object.alert.map(AlertUIAdapter.convert)
        )
    }
}
