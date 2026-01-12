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

    func getAquariums() async throws -> [AquariumData]
}

@InjectedMember(\.aquariumLocalDataSource)
@InjectedMember(\.aquariumRemoteDataSource)
final class AquariumRepository: AquariumRepositoryProtocol {
    
    // MARK: - AquariumRepository
    
    func getAquariums() async throws -> [AquariumData] {
        let dtos = try await aquariumRemoteDataSource.fetchAquariums()
        aquariumLocalDataSource.saveAquariums(aquariums: dtos.map(AquariumAdapter.convert), deleteOther: true)
        return aquariumLocalDataSource.getAquariums()
    }
}

extension InjectedValues {

    @Inject public var aquariumRepository: AquariumRepositoryProtocol = AquariumRepository()
}
