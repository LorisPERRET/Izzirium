//
//  RootCoordinatorViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Combine
import Data
import Domain
import Foundation
import Kastor
import SKDependencyInjection
import SKLocalStorage
import SKState

@MainActor
protocol RootCoordinatorViewModelProtocol: ObservableObject {
    
    var loginState: SKLoadingState<LoginState> { get }

    func fetchLoginState() async
    func onSuccessLogin()
}

@InjectedMember(\.isUserLoggedUseCase)
final class RootCoordinatorViewModel: RootCoordinatorViewModelProtocol {

    // MARK: - Properties

    @Published private(set) var loginState: SKLoadingState<LoginState> = .loading

    private let logger = Logger(category: RootCoordinatorViewModel.self)

    // MARK: - RootCoordinatorViewModelProtocol

    func fetchLoginState() async {
        logger.info("fetchLoginState")
        
        loginState = .loading
        
        let res = await isUserLoggedUseCase.perform()
        
        if res {
            loginState = .loaded(.logged)
        } else {
            loginState = .loaded(.unlogged)
        }
    }
    
    func onSuccessLogin() {
        loginState = .loaded(.logged)
    }
}
