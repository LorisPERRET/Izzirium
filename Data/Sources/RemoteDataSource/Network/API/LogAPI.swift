//
//  LogAPI.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
@preconcurrency import PapyrusAlamofire
import SKDependencyInjection

@Service
@JSON(encoder: JSONEncoderAPI(), decoder: JSONDecoderAPI())
@Headers(["accept": "application/json"])
protocol LogAPI: Sendable {
    
    @GET("/logs/:id")
    func getLogs(aquarium id: Int) async throws -> LogResponseDTO
}
