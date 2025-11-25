//
//  LogAdapter.swift
//  Data
//
//  Created by Benjamin Lambert on 28/10/2025.
//

enum LogAdapter {

    // MARK: Typealias

    typealias Input = LogDTO
    typealias Output = LogData

    // MARK: Adapter

    static func convert(from object: Input) -> Output {
        Output(
            date: object.date,
            ph: object.ph,
            tds: object.tds,
            turbidity: object.turbidity,
            temperature: object.temperature
        )
    }
}
