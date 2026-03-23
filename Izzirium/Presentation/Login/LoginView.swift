//
//  LoginView.swift
//  Izzirium
//
//  Created by Loris Perret on 18/03/2026.
//

import AuthenticationServices
import DesignSystem
import SwiftUI

struct LoginView<ViewModel>: View where ViewModel: LoginViewModelProtocol {

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            switch viewModel.loginRequestState {
            case .idle, .success, .error:
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.email]
                    },
                    onCompletion: { result in
                        Task {
                            await viewModel.callback(result: result)
                        }
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .padding(.horizontal)
                .errorToast(publisher: viewModel.loginRequestStatePublisher)
            case .loading:
                ProgressView()
                    .tint(.white)
            }
        }
        .expand(alignment: .center)
        .background(Color.primaryMedium)
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
}

#if DEBUG

#Preview("Idle") {
    LoginView(
        viewModel: FakeLoginViewModel(withState: .idle)
    )
}

#Preview("Loading") {
    LoginView(
        viewModel: FakeLoginViewModel(withState: .loading)
    )
}

#Preview("Failed") {
    LoginView(
        viewModel: FakeLoginViewModel(withState: .error(LoginViewModel.Error.common))
    )
}

#endif
