//
//  PairedBLEDevice.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
//

import Foundation

public struct PairedBLEDevice: Identifiable, Codable, Equatable, Sendable {

    public let id: String
    public let name: String
    public let model: String
    public let firmwareVersion: String
    public let lastConnectionDate: Date

    public init(
        id: String,
        name: String,
        model: String,
        firmwareVersion: String,
        lastConnectionDate: Date = .now
    ) {
        self.id = id
        self.name = name
        self.model = model
        self.firmwareVersion = firmwareVersion
        self.lastConnectionDate = lastConnectionDate
    }
}
