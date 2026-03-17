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
                baseURL: ServerConfiguration.baseURL
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
        do {
            return try await api.getLogs(aquarium: id)
        } catch let error as PapyrusError {
            logger.error("FetchLogs failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("FetchLogs status code: \(statusCode)")

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

    @Inject var logRemoteDataSource: LogRemoteDataSourceProtocol = LogRemoteDataSource.shared
}
