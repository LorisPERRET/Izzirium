//
//  LoginViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 18/03/2026.
//
//

import AuthenticationServices
//import Combine
//import Data
import Domain
import Foundation
//import Kastor
import SKDependencyInjection
//import SKLocalStorage
import SKState

@MainActor
protocol LoginViewModelProtocol: ObservableObject {
    
    var loginRequestState: SKDataRequestState<Void> { get }
    var loginRequestStatePublisher: SKDataRequestStatePublisher<Void> { get }

    var onSuccess: () -> Void { get }
    
    func handleAuthorization(_ authorization: ASAuthorization) async
    func callback(result: Result<ASAuthorization, any Swift.Error>) async
}

@InjectedMember(\.logUserUseCase)
final class LoginViewModel: LoginViewModelProtocol {

    // MARK: - Properties

    private(set) var onSuccess: () -> Void
    @Published private(set) var loginRequestState: SKDataRequestState<Void> = .idle
    var loginRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $loginRequestState
    }
    
    private let logger = Logger(category: LoginViewModel.self)
    
    // MARK: - Error
    
    enum Error: Swift.Error, LocalizedError {
        
        case common
        
        var errorDescription: String? {
            switch self {
            case .common:
                "Une erreur est survenue veillez réessayer."
            }
        }
    }

    // MARK: - Init
    
    init(onSuccess: @escaping () -> Void) {
        self.onSuccess = onSuccess
    }

    // MARK: - LoginViewModelProtocol
    
    func callback(result: Result<ASAuthorization, any Swift.Error>) async {
        loginRequestState = .loading
        
        switch result {
        case .success(let authorization):
            await handleAuthorization(authorization)
        case .failure(let error):
            logger.error(error.localizedDescription)
            
            loginRequestState = .error(Error.common)
        }
    }
    
    func handleAuthorization(_ authorization: ASAuthorization) async {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let tokenString = String(data: tokenData, encoding: .utf8) else {
            logger.error("Fail to retrieve identityToken")
            loginRequestState = .error(Error.common)
            return
        }
        
        do {
            try await logUserUseCase.perform(id: credential.user, token: tokenString, email: credential.email)
            loginRequestState = .success(())
            onSuccess()
        } catch {
            loginRequestState = .error(error)
            return
        }
    }
}
