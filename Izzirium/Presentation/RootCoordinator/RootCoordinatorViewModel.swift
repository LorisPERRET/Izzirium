//
//  RootCoordinatorViewModel.swift
//  I zzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Combine
import Data
//import Domain
import Foundation
//import Kastor
import SKDependencyInjection
import SKLocalStorage
import SKState

@MainActor
protocol RootCoordinatorViewModelProtocol: ObservableObject {
    
    var loginState: SKLoadingState<LoginState> { get }

    func onAppear() async
}

final class RootCoordinatorViewModel: RootCoordinatorViewModelProtocol {

    // MARK: - Properties

    @Published private(set) var loginState: SKLoadingState<LoginState> = .loading

//    private let logger = Logger(category: RootCoordinatorViewModel.self)

    // MARK: - RootCoordinatorViewModelProtocol

    func onAppear() async {
        loginState = .loaded(.logged)
    }
}
