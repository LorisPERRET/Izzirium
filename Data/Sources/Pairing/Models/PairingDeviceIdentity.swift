//
//  PairingDeviceIdentity.swift
//  Data
//
//  Created by Codex on 24/03/2026.
//

import Foundation

public struct PairingDeviceIdentity: Codable, Equatable, Sendable {

    public let deviceId: String
    public let name: String
    public let model: String?
    public let firmwareVersion: String?
    public let serialNumber: String?
    public let isPairingMode: Bool

    public init(
        deviceId: String,
        name: String,
        model: String? = nil,
        firmwareVersion: String? = nil,
        serialNumber: String? = nil,
        isPairingMode: Bool
    ) {
        self.deviceId = deviceId
        self.name = name
        self.model = model
        self.firmwareVersion = firmwareVersion
        self.serialNumber = serialNumber
        self.isPairingMode = isPairingMode
    }
}
