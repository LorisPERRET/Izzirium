//
//  PairingProvisioningStatus.swift
//  Data
//
//  Created by Codex on 24/03/2026.
//

import Foundation

public enum PairingProvisioningStatus: Codable, Equatable, Sendable {

    case idle
    case sendingCredentials
    case connectingToNetwork
    case registeringToBackend
    case completed
    case failed(reason: String)
}
