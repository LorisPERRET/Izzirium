//
//  DataError.swift
//  Data
//
//  Created by Loris Perret on 25/08/2025.
//

import Foundation

public enum DataError: Error, LocalizedError {

    case decoding
    case invalidCredentials
    case network
    
    public var errorDescription: String? {
        switch self {
        case .decoding, .network:
            "Une erreur est survenue. Veuillez réessayer."
        case .invalidCredentials:
            "Vous devez être connecté pour faire cette action."
        }
    }
}
