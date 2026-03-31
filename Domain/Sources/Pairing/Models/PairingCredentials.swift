//
//  PairingCredentials.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
//

import Foundation

public struct PairingCredentials: Codable, Equatable, Sendable {

    public let wifiSSID: String
    public let wifiPassword: String
    public let sensorId: String

    public init(
        wifiSSID: String,
        wifiPassword: String,
        sensorId: String,
    ) {
        self.wifiSSID = wifiSSID
        self.wifiPassword = wifiPassword
        self.sensorId = sensorId
    }
}
