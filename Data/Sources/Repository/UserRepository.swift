//
//  UserRepository.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
public protocol UserRepositoryProtocol: Sendable {
    
    func setUserId(_ id: String?) async
    func getUserId() async -> String?
    func authApple(identityToken: String, email: String?) async throws
    func postDeviceToken(token: String) async throws
}

@InjectedMember(\.userLocalDataSource)
@InjectedMember(\.userRemoteDataSource)
final class UserRepository: UserRepositoryProtocol {
    
    // MARK: - UserRepository
    
    func setUserId(_ id: String?) async {
        await userLocalDataSource.setUserId(id)
    }
    
    func getUserId() async -> String? {
        await userLocalDataSource.getUserId()
    }
    
    func authApple(identityToken: String, email: String?) async throws {
        try await userRemoteDataSource.authApple(identityToken: identityToken, email: email)
    }

    func postDeviceToken(token: String) async throws {
        try await userRemoteDataSource.postDeviceToken(token: token)
    }
}

extension InjectedValues {

    @Inject public var userRepository: UserRepositoryProtocol = UserRepository()
}
