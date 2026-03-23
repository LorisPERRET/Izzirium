// swiftlint:disable:this file_name

//
//  APIProvider.swift
//  Data
//
//  Created by Loris Perret on 25/06/2025.

import Alamofire
import Foundation
import PapyrusAlamofire

extension Provider {

    enum SessionType {

        case authenticate//(AuthenticationRepositoryProtocol)
        case unauthenticate

        var isAuthenticated: Bool {
            switch self {
            case .authenticate:
                true
            case .unauthenticate:
                false
            }
        }

//        var authenticationRepository: AuthenticationRepositoryProtocol? {
//            switch self {
//            case let .authenticate(repository):
//                repository
//            case .unauthenticate:
//                nil
//            }
//        }
    }

    /// Creates and configures a network Provider instance for API communication
    /// - Parameters:
    ///   - baseURL: The base URL for the API endpoints
    ///   - authorizationValue: Optional authorization token for authenticated requests
    /// - Returns: A configured Provider instance ready for making API requests
    static func apiProvider(
        baseURL: String,
        sessionType: SessionType = .unauthenticate,
        authorizationValue: String? = nil
    ) -> Provider {
        // Create default session configuration
        let sessionConfiguration = URLSessionConfiguration.af.default
        // Disable cookie handling for this session
        sessionConfiguration.httpShouldSetCookies = false

        // Add authorization header if provided
        if let authorizationValue {
            // Escape newlines in authorization value
            let authorizationHeaderValue = authorizationValue
                .replacingOccurrences(of: "\n", with: "\\n")
            // Set authorization header with properly formatted value
            sessionConfiguration.httpAdditionalHeaders = [
                "Authorization": "\"\(authorizationHeaderValue)\""
            ]
        }
//
//        var onNeedReauthentication: (() async -> Void)?
//        if let authenticationRepository = sessionType.authenticationRepository {
//            onNeedReauthentication = {
//                try? await authenticationRepository.refresh()
//            }
//        }

        // Create Alamofire session with configuration and logging
        let session = Alamofire.Session(
            configuration: sessionConfiguration,
            interceptor: APIRequestInterceptor(
                needAuthorization: sessionType.isAuthenticated,
                onNeedReauthentication: nil//onNeedReauthentication
            ),
            eventMonitors: [APILogger()]
        )

        // Return configured Provider instance
        return Provider(
            baseURL: baseURL,
            session: session
        )
    }
}
