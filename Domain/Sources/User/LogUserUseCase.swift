//
//  LogUserUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import AuthenticationServices
import Data
import Foundation
import Kastor
import SKDependencyInjection

@MainActor
public protocol LogUserUseCaseProtocol: Sendable {

    func perform(id: String, token: String, email: String?) async throws
}

@InjectedMember(\.userRepository)
final class LogUserUseCase: LogUserUseCaseProtocol {
    
    // MARK: - Properties

    private let logger = Logger(category: LogUserUseCase.self)

    // MARK: - Error
    
    enum Error: Swift.Error, LocalizedError {
        
        case noDeviceToken
        
        var errorDescription: String? {
            switch self {
            case .noDeviceToken:
                "Une erreur est survenue veillez réessayer."
            }
        }
    }

    // MARK: LogUserUseCaseProtocol

    func perform(id: String, token: String, email: String?) async throws {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            logger.error("No device token")
            throw Error.noDeviceToken
        }

        try await userRepository.authApple(identityToken: token, email: email)
        try await userRepository.postDeviceToken(token: deviceId)
        await userRepository.setUserId(id)
    }
}

extension InjectedValues {

    @Inject public var logUserUseCase: LogUserUseCaseProtocol = LogUserUseCase()
}
