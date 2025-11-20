//
//  LoginState.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import SwiftUI

private struct LoginStateEnvironmentKey: EnvironmentKey {

    static let defaultValue: LoginState = .unlogged
}

enum LoginState: Equatable {

    case logged
    case unlogged
    case withoutLogin
}

extension EnvironmentValues {

    var loginState: LoginState {
        get { self[LoginStateEnvironmentKey.self] }
        set { self[LoginStateEnvironmentKey.self] = newValue }
    }
}
