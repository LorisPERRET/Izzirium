//
//  FakeRootCoordinatorViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

#if DEBUG

import Foundation
import SKState

final class FakeRootCoordinatorViewModel: RootCoordinatorViewModelProtocol {

    // MARK: - Properties

    let loginState: SKLoadingState<LoginState>

    // MARK: - Init

    init(
        withLoginState loginState: SKLoadingState<LoginState>
    ) {
        self.loginState = loginState
    }

    // MARK: - RootCoordinatorViewModelProtocol

    func fetchLoginState() {}
}

#endif
