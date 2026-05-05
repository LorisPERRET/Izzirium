//
//  UserLocalDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection
import SKLocalStorage

@MainActor
protocol UserLocalDataSourceProtocol: Sendable {

    func setUserId(_ id: String?) async
    func getUserId() async -> String?
    func setEmail(_ email: String?) async
    func getEmail() async -> String?
    func getAccessTokenExpirationDate() async -> Date?
}

@InjectedMember(\.keychainStorage, protocol: (any KeychainStorageProtocol<KeychainStorageKey>).self)
final class UserLocalDataSource: UserLocalDataSourceProtocol {

    // MARK: - Properties

    private let logger = Logger(category: UserLocalDataSource.self)

    // MARK: - UserLocalDataSourceProtocol

    func setUserId(_ id: String?) async {
        do {
            if let id {
                try await keychainStorage.setString(value: id, forKey: .userId)
            } else {
                try await keychainStorage.delete(key: .userId)
            }
        } catch {
            logger.error(error.localizedDescription)
        }
    }
    
    func getUserId() async -> String? {
        do {
            return try await keychainStorage.getString(key: .userId)
        } catch {
            logger.error(error.localizedDescription)
            return nil
        }
    }
    
    func setEmail(_ email: String?) async {
        do {
            if let email {
                try await keychainStorage.setString(value: email, forKey: .email)
            } else {
                try await keychainStorage.delete(key: .email)
            }
        } catch {
            logger.error(error.localizedDescription)
        }
    }
    
    func getEmail() async -> String? {
        do {
            return try await keychainStorage.getString(key: .email)
        } catch {
            logger.error(error.localizedDescription)
            return nil
        }
    }
    
    func getAccessTokenExpirationDate() async -> Date? {
        do {
            guard let date = try await keychainStorage.getString(key: .accessTokenExpirationDate) else {
                return nil
            }
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: date)
        } catch {
            logger.error(error.localizedDescription)
            return nil
        }
    }
}

extension InjectedValues {

    @Inject var userLocalDataSource: UserLocalDataSourceProtocol = UserLocalDataSource()
}
