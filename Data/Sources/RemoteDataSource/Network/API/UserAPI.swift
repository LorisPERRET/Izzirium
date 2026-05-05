//
//  UserAPI.swift
//  Data
//
//  Created by Loris Perret on 18/03/2026.
//

import Foundation
@preconcurrency import PapyrusAlamofire
import SKDependencyInjection

@Service
@JSON(encoder: JSONEncoderAPI(), decoder: JSONDecoderAPI())
@Headers(["accept": "application/json"])
protocol UserAPI: Sendable {
    
    @POST("/auth/apple")
    func authApple(identityToken: String, email: String) async throws -> AuthAppleResponseDTO
    
    @POST("/auth/refresh")
    func authRefresh(refreshToken: String) async throws -> AuthAppleResponseDTO
    
    @POST("/device-tokens")
    func postDeviceToken(token: String) async throws
}
