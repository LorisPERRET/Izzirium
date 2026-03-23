//
//  FakeLoginViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 18/03/2026.
//

#if DEBUG

import AuthenticationServices
import Combine
import Foundation
import SKState

final class FakeLoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Properties

    @Published var loginRequestState: SKState.SKDataRequestState<Void>
    var loginRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $loginRequestState
    }
    let onSuccess: () -> Void

    // MARK: - Init
    
    init(withState loginRequestState: SKState.SKDataRequestState<Void>) {
        self.onSuccess = {}
        self.loginRequestState = loginRequestState
    }

    // MARK: - LoginViewModelProtocol
    
    func handleAuthorization(_ authorization: ASAuthorization) {}
    func callback(result: Result<ASAuthorization, any Error>) async {}
}

#endif
