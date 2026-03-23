//
//  KeychainStorageKey.swift
//  Data
//
//  Created by Loris Perret on 25/06/2025.
//

import SKDependencyInjection
import SKLocalStorage

enum KeychainStorageKey: String, KeychainKey, Sendable, Equatable {

    // MARK: Cases

    case accessToken
    case accessTokenExpirationDate
    case refreshToken
    case userId
    case email

    // MARK: - Keychain

    static let serviceName = "loris.perret.izima.izzirium.userdefault.keychain"
}

extension InjectedValues {

    @Inject var keychainStorage: any KeychainStorageProtocol<KeychainStorageKey> = KeychainStorage<KeychainStorageKey>()
}
