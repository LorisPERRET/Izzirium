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
    func fetchPrediction(aquarium id: Int) async throws -> PredictResponseDTO
    func createAquarium(name: String) async throws-> AquariumDTO
    func deleteAquarium(id: Int) async throws
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

    func fetchPrediction(aquarium id: Int) async throws -> PredictResponseDTO {
        try await APIUtils.request("fetchPrediction", logger: logger) {
            try await api.getPrediction(aquarium: id)
        }
    }

    func createAquarium(name: String) async throws-> AquariumDTO {
        try await APIUtils.request("createAquarium", logger: logger) {
            return try await api.createAquarium(name: name)
        }
    }

    func deleteAquarium(id: Int) async throws {
        try await APIUtils.request("deleteAquarium", logger: logger) {
            try await api.deleteAquarium(aquarium: id)
        }
    }
}

extension InjectedValues {

    @Inject var aquariumRemoteDataSource: AquariumRemoteDataSourceProtocol = AquariumRemoteDataSource.shared
}
