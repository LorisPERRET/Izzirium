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

    public var title: String {
        switch self {
        case .idle:
            "Bluetooth pret"
        case .checkingPermissions:
            "Verification du Bluetooth..."
        case .bluetoothUnavailable:
            "Bluetooth indisponible"
        case .scanning:
            "Scan en cours..."
        case .deviceFound(let devices):
            "\(devices.count) appareil(s) trouve(s)"
        case .connecting(let device):
            "Connexion a \(device.name)..."
        case .deviceReady(let device):
            "Connecte a \(device.name)"
        case .provisioning(let device):
            "Envoi du Wi-Fi a \(device.name)..."
        case .success:
            "Configuration terminee"
        case .failed(let error):
            error.localizedDescription
        }
    }
}
