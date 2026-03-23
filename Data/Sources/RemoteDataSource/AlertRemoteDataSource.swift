//
//  AlertRemoteDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import PapyrusAlamofire
import SKDependencyInjection

protocol AlertRemoteDataSourceProtocol: Sendable {

    func fetchAlert(aquarium id: Int) async throws-> AlertDTO?
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
        do {
            return try await api.getAlert(aquarium: id)
        } catch let error as PapyrusError {
            logger.error("FetchAlerts failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("FetchAlerts status code: \(statusCode)")

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

    @Inject var alertRemoteDataSource: AlertRemoteDataSourceProtocol = AlertRemoteDataSource.shared
}
