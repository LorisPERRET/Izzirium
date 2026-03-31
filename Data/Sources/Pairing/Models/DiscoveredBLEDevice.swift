//
//  DiscoveredBLEDevice.swift
//  Data
//
//  Created by Codex on 24/03/2026.
//

import Foundation

public struct DiscoveredBLEDevice: Identifiable, Codable, Equatable, Sendable {

    public let id: String
    public let name: String
    public let rssi: Int
    public let model: String?
    public let firmwareVersion: String?
    public let isPairingMode: Bool
    public let advertisedServiceUUIDs: [String]

    public init(
        id: String,
        name: String,
        rssi: Int,
        model: String? = nil,
        firmwareVersion: String? = nil,
        isPairingMode: Bool,
        advertisedServiceUUIDs: [String] = []
    ) {
        self.id = id
        self.name = name
        self.rssi = rssi
        self.model = model
        self.firmwareVersion = firmwareVersion
        self.isPairingMode = isPairingMode
        self.advertisedServiceUUIDs = advertisedServiceUUIDs
    }
}
