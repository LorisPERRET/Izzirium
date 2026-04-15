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
    func createAquarium(name: String) async throws-> AquariumDTO
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
                baseURL: ServerConfiguration.baseURL,
                sessionType: .authenticate
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
        try await APIUtils.request("fetchAquariums", logger: logger) {
            return try await api.getAquariums()
        }
    }

    func createAquarium(name: String) async throws-> AquariumDTO {
        try await APIUtils.request("createAquarium", logger: logger) {
            return try await api.createAquarium(name: name)
        }
    }
}

extension InjectedValues {

    @Inject var aquariumRemoteDataSource: AquariumRemoteDataSourceProtocol = AquariumRemoteDataSource.shared
}
