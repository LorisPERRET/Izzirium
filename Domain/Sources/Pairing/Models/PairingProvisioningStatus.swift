//
//  PairingProvisioningStatus.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
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
