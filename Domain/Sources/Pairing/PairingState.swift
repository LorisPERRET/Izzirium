//
//  PairingState.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
//

import Foundation

public enum PairingState: Equatable, Sendable {

    case idle
    case checkingPermissions
    case bluetoothUnavailable
    case scanning
    case deviceFound([DiscoveredBLEDevice])
    case connecting(DiscoveredBLEDevice)
    case deviceReady(PairingDeviceIdentity)
    case provisioning(PairingDeviceIdentity)
    case success
    case failed(PairingError)
}
