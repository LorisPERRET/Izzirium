//
//  IsUserLoggedUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import AuthenticationServices
import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol IsUserLoggedUseCaseProtocol: Sendable {

    func perform() async -> Bool
}

@InjectedMember(\.userRepository)
final class IsUserLoggedUseCase: IsUserLoggedUseCaseProtocol {

    // MARK: IsUserLoggedUseCaseProtocol

    func perform() async -> Bool {
        guard let id = await userRepository.getUserId() else { return false }
        
        do {
            let state = try await ASAuthorizationAppleIDProvider().credentialState(forUserID: id)
            
            switch state {
            case .authorized:
                let isExpired = await userRepository.isLoginExpired()
                if isExpired {
                    try await userRepository.refreshToken()
                }
                
                return true
            default:
                return false
            }
        } catch {
            return false
        }
    }
}

extension InjectedValues {

    @Inject public var isUserLoggedUseCase: IsUserLoggedUseCaseProtocol = IsUserLoggedUseCase()
}
