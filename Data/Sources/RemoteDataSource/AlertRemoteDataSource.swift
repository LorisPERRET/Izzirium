//
//  AlertRemoteDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import PapyrusAlamofire
import SKDependencyInjection

protocol AlertRemoteDataSourceProtocol: Sendable {

    func fetchAlert(aquarium id: Int) async throws -> AlertDTO?
    func updateAlert(alert: AlertRequestDTO) async throws -> AlertDTO
}

@Singleton
final class AlertRemoteDataSource: AlertRemoteDataSourceProtocol {
    
    // MARK: - Properties

    private let api: AlertAPI

    private let logger = Logger(category: AlertRemoteDataSource.self)
    
    init() {
#if API_MOCK
        self.api = FakeAlertAPI()
#else
        self.api = AlertAPIService(
            provider: Provider.apiProvider(
                baseURL: ServerConfiguration.baseURL,
                sessionType: .authenticate
            )
        )
#endif
    }

#if DEBUG
    init(api: AlertAPI) {
        self.api = api
    }
#endif
    
    // MARK: - AlertRemoteDataSourceProtocol
    
    func fetchAlert(aquarium id: Int) async throws -> AlertDTO? {
        try await APIUtils.request("fetchAlert", logger: logger) {
            try await api.getAlert(aquarium: id)
        }
    }
    
    func updateAlert(alert: AlertRequestDTO) async throws -> AlertDTO {
        try await APIUtils.request("updateAlert", logger: logger) {
            return try await api.updateAlert(alert: alert)
        }
    }
}

extension InjectedValues {

    @Inject var alertRemoteDataSource: AlertRemoteDataSourceProtocol = AlertRemoteDataSource.shared
}
