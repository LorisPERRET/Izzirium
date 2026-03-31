//
//  SendDeviceTokenUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import Kastor
import SKDependencyInjection

@MainActor
public protocol SendDeviceTokenUseCaseProtocol: Sendable {

    func perform(token: String) async throws
}

@InjectedMember(\.userRepository)
final class SendDeviceTokenUseCase: SendDeviceTokenUseCaseProtocol {
    
    // MARK: - Properties

    private let logger = Logger(category: SendDeviceTokenUseCase.self)

    // MARK: LogUserUseCaseProtocol

    func perform(token: String) async throws {
        try await userRepository.postDeviceToken(token: token)
    }
}

extension InjectedValues {

    @Inject public var sendDeviceTokenUseCase: SendDeviceTokenUseCaseProtocol = SendDeviceTokenUseCase()
}
