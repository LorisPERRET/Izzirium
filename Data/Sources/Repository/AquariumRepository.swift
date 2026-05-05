//
//  AquariumRepository.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
public protocol AquariumRepositoryProtocol: Sendable {

    func setFavorite(aquarium id: Int?) async
    func getFavoriteAquarium() async -> AquariumData?
    func getAquariums() async throws -> [AquariumData]
    func createAquarium(name: String) async throws -> AquariumData
    func deleteAquarium(id: Int) async throws
}

@InjectedMember(\.aquariumLocalDataSource)
@InjectedMember(\.aquariumRemoteDataSource)
final class AquariumRepository: AquariumRepositoryProtocol {
    
    // MARK: - AquariumRepository
    
    func setFavorite(aquarium id: Int?) async {
        await aquariumLocalDataSource.setFavoriteAquarium(id: id)
    }
    
    func getFavoriteAquarium() async -> AquariumData? {
        guard let id = await aquariumLocalDataSource.getFavoriteAquariumId() else { return nil }
        
        return try? aquariumLocalDataSource.getAquarium(byId: id)
    }
    
    func getAquariums() async throws -> [AquariumData] {
        let dtos = try await aquariumRemoteDataSource.fetchAquariums()
        aquariumLocalDataSource.saveAquariums(aquariums: dtos.map(AquariumAdapter.convert), deleteOther: true)
        return aquariumLocalDataSource.getAquariums()
    }

    func createAquarium(name: String) async throws -> AquariumData {
        let dto = try await aquariumRemoteDataSource.createAquarium(name: name)
        aquariumLocalDataSource.saveAquariums(aquariums: [AquariumAdapter.convert(from: dto)], deleteOther: false)
        return try aquariumLocalDataSource.getAquarium(byId: dto.id)
    }

    func deleteAquarium(id: Int) async throws {
        try await aquariumRemoteDataSource.deleteAquarium(id: id)
        try aquariumLocalDataSource.deleteAquarium(byId: id)

        if await aquariumLocalDataSource.getFavoriteAquariumId() == id {
            await aquariumLocalDataSource.setFavoriteAquarium(id: nil)
        }
    }
}

extension InjectedValues {

    @Inject public var aquariumRepository: AquariumRepositoryProtocol = AquariumRepository()
}
