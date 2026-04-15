//
//  LogRemoteDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import PapyrusAlamofire
import SKDependencyInjection

protocol LogRemoteDataSourceProtocol: Sendable {

    func fetchLogs(aquarium id: Int) async throws-> [LogDTO]
}

@Singleton
final class LogRemoteDataSource: LogRemoteDataSourceProtocol {
    
    // MARK: - Properties

    private let api: LogAPI

    private let logger = Logger(category: LogRemoteDataSource.self)
    
    init() {
#if API_MOCK
        self.api = FakeLogAPI()
#else
        self.api = LogAPIService(
            provider: Provider.apiProvider(
                baseURL: ServerConfiguration.baseURL,
                sessionType: .authenticate
            )
        )
#endif
    }

#if DEBUG
    init(api: LogAPI) {
        self.api = api
    }
#endif
    
    // MARK: - LogRemoteDataSourceProtocol
    
    func fetchLogs(aquarium id: Int) async throws -> [LogDTO] {
        try await APIUtils.request("fetchLogs", logger: logger) {
            return try await api.getLogs(aquarium: id)
        }
    }
}

extension InjectedValues {

    @Inject var logRemoteDataSource: LogRemoteDataSourceProtocol = LogRemoteDataSource.shared
}
