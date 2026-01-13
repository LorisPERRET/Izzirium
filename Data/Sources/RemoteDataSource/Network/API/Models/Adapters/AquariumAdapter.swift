//
//  AquariumAdapter.swift
//  Data
//
//  Created by Benjamin Lambert on 28/10/2025.
//

enum AquariumAdapter {

    // MARK: Typealias

    typealias Input = AquariumDTO
    typealias Output = AquariumData

    // MARK: Adapter

    static func convert(from object: Input) -> Output {
        Output(
            modelId: object.id,
            name: object.name,
            logs: []
        )
    }
}
