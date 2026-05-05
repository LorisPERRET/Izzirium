//
//  AuthAppleResponseDTO.swift
//  Data
//
//  Created by Loris Perret on 23/03/2026.
//

import Foundation

struct AuthAppleResponseDTO: Codable, Sendable, Equatable {
    
    let token: String
    let refreshToken: String
    let expiresAt: Date
}
