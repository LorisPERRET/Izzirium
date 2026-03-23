//
//  UserRemoteDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Alamofire
import PapyrusAlamofire
import SKDependencyInjection
import SKLocalStorage

protocol UserRemoteDataSourceProtocol: Sendable {

    func authApple(identityToken: String, email: String?) async throws
    func postDeviceToken(token: String) async throws
}

@InjectedMember(\.keychainStorage, protocol: (any KeychainStorageProtocol<KeychainStorageKey>).self)
@InjectedMember(\.userLocalDataSource)
@Singleton
final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    
    // MARK: - Error
    
    enum Error: Swift.Error, LocalizedError {
        
        case noEmail
        
        var errorDescription: String? {
            switch self {
            case .noEmail:
                "Une erreur est survenue. Veuillez réessayer."
            }
        }
    }

    
    // MARK: - Properties

    private let unauthenticatedAPI: UserAPI
    private let authenticatedAPI: UserAPI

    private let logger = Logger(category: UserRemoteDataSource.self)
    
    init() {
#if API_MOCK
        self.unauthenticatedAPI = FakeUserAPI()
        self.authenticatedAPI = FakeUserAPI()
#else
        self.unauthenticatedAPI = UserAPIService(
            provider: Provider.apiProvider(
                baseURL: ServerConfiguration.baseURL
            )
        )
        self.authenticatedAPI = UserAPIService(
            provider: Provider.apiProvider(
                baseURL: ServerConfiguration.baseURL,
                sessionType: .authenticate
            )
        )
#endif
    }

#if DEBUG
    init(unauthenticatedAPI: UserAPI, authenticatedAPI: UserAPI) {
        self.unauthenticatedAPI = unauthenticatedAPI
        self.authenticatedAPI = authenticatedAPI
    }
#endif
    
    // MARK: - UserRemoteDataSourceProtocol
    
    func authApple(identityToken: String, email: String?) async throws {
        do {
            let newEmail: String
            if let email {
                newEmail = email
                await userLocalDataSource.setEmail(email)
            } else {
                guard let keychainEmail = await userLocalDataSource.getEmail() else {
                    logger.error("failed to get email from keychain")
                    throw Error.noEmail
                }
                newEmail = keychainEmail
            }
            
            let response = try await unauthenticatedAPI.authApple(identityToken: identityToken, email: newEmail)
            try await keychainStorage.setString(value: response.token, forKey: .accessToken)
            
        } catch let error as PapyrusError {
            logger.error("authApple failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("authApple status code: \(statusCode)")

            throw DataError.network
        } catch let error as DecodingError {
            logger.error(error.localizedDescription)
            throw DataError.decoding
        } catch {
            logger.error(error.localizedDescription)
            throw DataError.network
        }
    }
    
    func postDeviceToken(token: String) async throws {
        do {
            return try await authenticatedAPI.postDeviceToken(token: token)
        } catch let error as AFError {
            if case .responseSerializationFailed(reason: .inputDataNilOrZeroLength) = error {
                // The endpoint returns HTTP 200 with an empty body. Treat that as success.
                return
            }
            throw DataError.network
        } catch let error as PapyrusError {
            logger.error("postDeviceToken failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("postDeviceToken status code: \(statusCode)")

            throw DataError.network
        } catch let error as DecodingError {
            logger.error(error.localizedDescription)
            throw DataError.decoding
        } catch {
            logger.error(error.localizedDescription)
            throw DataError.network
        }
    }
}

extension InjectedValues {

    @Inject var userRemoteDataSource: UserRemoteDataSourceProtocol = UserRemoteDataSource.shared
}
