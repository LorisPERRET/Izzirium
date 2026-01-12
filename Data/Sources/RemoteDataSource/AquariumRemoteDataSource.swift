//
//  AquariumRemoteDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import PapyrusAlamofire
import SKDependencyInjection

protocol AquariumRemoteDataSourceProtocol: Sendable {

    func fetchAquariums() async throws-> [AquariumDTO]
}

@Singleton
final class AquariumRemoteDataSource: AquariumRemoteDataSourceProtocol {
    
    // MARK: - Properties

    private let api: AquariumAPI

    private let logger = Logger(category: AquariumRemoteDataSource.self)
    
    init() {
#if API_MOCK
        self.api = FakeAquariumAPI()
#else
        self.api = AquariumAPIService(
            provider: Provider.apiProvider(
                baseURL: ServerConfiguration.baseURL
            )
        )
#endif
    }

#if DEBUG
    init(api: AquariumAPI) {
        self.api = api
    }
#endif
    
    // MARK: - AquariumRemoteDataSourceProtocol

    func fetchAquariums() async throws -> [AquariumDTO] {
        do {
            return try await api.getAquariums()
        } catch let error as PapyrusError {
            logger.error("FetchAquariums failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("FetchAquariums status code: \(statusCode)")

            throw DataError.network
        } catch let error as DecodingError {
            print(error)
            logger.error(error.localizedDescription)
            throw DataError.decoding
        }
    }
}

extension InjectedValues {

    @Inject var aquariumRemoteDataSource: AquariumRemoteDataSourceProtocol = AquariumRemoteDataSource.shared
}
