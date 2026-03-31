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
@InjectedMember(\.requestPushNotificationUseCase)
@InjectedMember(\.requestPushNotificationStatusUseCase)
final class LogUserUseCase: LogUserUseCaseProtocol {
    
    // MARK: - Properties

    private let logger = Logger(category: LogUserUseCase.self)

    // MARK: LogUserUseCaseProtocol

    func perform(id: String, token: String, email: String?) async throws {
        try await userRepository.authApple(identityToken: token, email: email)
        
        if await requestPushNotificationStatusUseCase.perform() == nil {
            try await requestPushNotificationUseCase.perform()
        }
        
        await userRepository.setUserId(id)
    }
}

extension InjectedValues {

    @Inject public var logUserUseCase: LogUserUseCaseProtocol = LogUserUseCase()
}
