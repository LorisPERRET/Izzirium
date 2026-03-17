//
//  AlertRepository.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
public protocol AlertRepositoryProtocol: Sendable {

    func getAlert(aquarium id: Int) async throws -> AlertData?
}

@InjectedMember(\.aquariumLocalDataSource)
@InjectedMember(\.alertLocalDataSource)
@InjectedMember(\.alertRemoteDataSource)
final class AlertRepository: AlertRepositoryProtocol {
    
    // MARK: - AlertRepository
    
    func getAlert(aquarium id: Int) async throws -> AlertData? {
        guard let dto = try await alertRemoteDataSource.fetchAlert(aquarium: id) else { return nil }

        let aquarium = try aquariumLocalDataSource.getAquarium(byId: id)
        aquarium.alert = AlertAdapter.convert(from: dto)
        aquariumLocalDataSource.saveAquariums(aquariums: [aquarium], deleteOther: false)
        return try alertLocalDataSource.getAlert(aquarium: id)
    }
}

extension InjectedValues {

    @Inject public var alertRepository: AlertRepositoryProtocol = AlertRepository()
}
