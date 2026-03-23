//
//  APIRequestInterceptor.swift
//  Data
//
//  Created by Benjamin Lambert on 17/10/2025.
//

import Alamofire
import Foundation
import SKDependencyInjection
import SKLocalStorage

struct APIRequestRetrier {

    private let unauthentifiedStatusCode = 401

    private let attempts: Int
    private var onNeedReauthentication: (() async -> Void)?

    init(
        attempts: Int,
        onNeedReauthentication: (() async -> Void)?
    ) {
        self.attempts = attempts
        self.onNeedReauthentication = onNeedReauthentication
    }

    func handle(statusCode: Int?, retryCount: Int) async -> RetryResult {
        // 401 - 👮 Unauthentified
        guard statusCode == unauthentifiedStatusCode else {
            return .doNotRetry
        }

        // Max retry count reach
        guard retryCount >= attempts else {
            return .doNotRetry
        }

        guard let onNeedReauthentication else {
            return .doNotRetry
        }

        //        fatalError("\(#file).swift: `retry` method must be implemented")
        await onNeedReauthentication()
        return .retry
    }
}

@InjectedMember(\.keychainStorage, protocol: (any KeychainStorageProtocol<KeychainStorageKey>).self)
final class APIRequestInterceptor: RequestInterceptor, @unchecked Sendable {

    // MARK: - Properties

    private let needAuthorization: Bool
    private let requestRetrier: APIRequestRetrier

    // MARK: - Init

    init(
        needAuthorization: Bool,
        onNeedReauthentication: (() async -> Void)?,
        attempts: Int = 3
    ) {
        self.needAuthorization = needAuthorization
        self.requestRetrier = APIRequestRetrier(
            attempts: attempts,
            onNeedReauthentication: onNeedReauthentication
        )
    }

    // MARK: - Adapt

    func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping @Sendable (Swift.Result<URLRequest, Error>) -> Void
    ) {
        guard needAuthorization else {
            completion(.success(urlRequest))
            return
        }

        Task {
            do {
                var authenticatedRequest = urlRequest
                if let accessToken = try await self.keychainStorage.getString(key: .accessToken) {
                    authenticatedRequest.headers.add(.authorization(bearerToken: accessToken))
                }
                completion(.success(authenticatedRequest))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Retry

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping @Sendable (RetryResult) -> Void
    ) {
        Task {
            let result = await requestRetrier.handle(
                statusCode: request.response?.statusCode,
                retryCount: request.retryCount
            )
            completion(result)
        }
    }
}
