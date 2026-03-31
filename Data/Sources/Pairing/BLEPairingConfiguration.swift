//
//  BLEPairingConfiguration.swift
//  Data
//
//  Created by Codex on 24/03/2026.
//

import Foundation

public struct BLEPairingConfiguration: Equatable, Sendable {

    public struct CharacteristicCatalog: Equatable, Sendable {

        public let deviceInfo: String
        public let wifiConfigurationWrite: String
        public let provisioningStatus: String

        public init(
            deviceInfo: String,
            wifiConfigurationWrite: String,
            provisioningStatus: String
        ) {
            self.deviceInfo = deviceInfo
            self.wifiConfigurationWrite = wifiConfigurationWrite
            self.provisioningStatus = provisioningStatus
        }
    }

    public let serviceUUIDs: [String]
    public let characteristics: CharacteristicCatalog
    public let deviceNamePrefix: String?

    public init(
        serviceUUIDs: [String],
        characteristics: CharacteristicCatalog,
        deviceNamePrefix: String? = nil
    ) {
        self.serviceUUIDs = serviceUUIDs
        self.characteristics = characteristics
        self.deviceNamePrefix = deviceNamePrefix
    }
}
