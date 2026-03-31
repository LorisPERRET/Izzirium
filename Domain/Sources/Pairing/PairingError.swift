//
//  PairingError.swift
//  Domain
//
//  Created by Loris on 24/03/2026.
//

import Foundation

public enum PairingError: Error, Equatable, LocalizedError, Sendable {

    case bluetoothUnavailable
    case bluetoothUnauthorized
    case invalidConfiguration(reason: String)
    case deviceNotFound
    case connectionFailed(reason: String? = nil)
    case provisioningFailed(reason: String? = nil)
    case timeout
    case notImplemented(feature: String)
    case unknown(reason: String? = nil)

    public var errorDescription: String? {
        switch self {
        case .bluetoothUnavailable:
            "Le Bluetooth est indisponible."
        case .bluetoothUnauthorized:
            "L'autorisation Bluetooth est refusée."
        case .invalidConfiguration(let reason):
            reason
        case .deviceNotFound:
            "Impossible de retrouver l'objet sélectionné."
        case .connectionFailed(let reason):
            reason ?? "La connexion à l'objet a échoué."
        case .provisioningFailed(let reason):
            reason ?? "L'envoi de la configuration a échoué."
        case .timeout:
            "L'opération a dépassé le délai autorisé."
        case .notImplemented(let feature):
            "\(feature) n'est pas encore implémenté."
        case .unknown(let reason):
            reason ?? "Une erreur inconnue est survenue."
        }
    }
}
