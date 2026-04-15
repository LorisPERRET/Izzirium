//
//  FakeUserAPI.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation

#if API_MOCK

import Foundation
import PapyrusAlamofire

final class FakeUserAPI: UserAPI {

    // MARK: - Properties

    let sleepTime: UInt64 = 2_000_000_000

    // MARK: - UserAPI

    func authApple(identityToken: String, email: String) async throws -> AuthAppleResponseDTO {
        AuthAppleResponseDTO(token: "token")
    }

    func postDeviceToken(token: String) async throws {}
}

#endif
