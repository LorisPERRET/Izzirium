//
//  UserDefaultsStorageKey.swift
//  SKDevKit
//
//  Created by Thibaut Schmitt on 18/04/2025.
//

import SKDependencyInjection
import SKLocalStorage

enum UserDefaultsStorageKey: UserDefaultsKey, Sendable, Equatable {

    // MARK: - UserDefaults

    static let suiteName = "loris.perret.izima.izzirium.userdefault"
}

extension InjectedValues {

    @Inject var userDefaultsStorage: any UserDefaultsStorageProtocol<UserDefaultsStorageKey> = UserDefaultsStorage<UserDefaultsStorageKey>()
}
