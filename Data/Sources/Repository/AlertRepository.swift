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
    func updateAlert(alert: AlertRequestDTO) async throws
}

@InjectedMember(\.aquariumLocalDataSource)
@InjectedMember(\.alertLocalDataSource)
@InjectedMember(\.alertRemoteDataSource)
final class AlertRepository: AlertRepositoryProtocol {
    
    // MARK: - Error
    
    enum Error: Swift.Error, LocalizedError {
        
        case aquariumNotFound
        
        var errorDescription: String? {
            switch self {
            case .aquariumNotFound:
                "Impossible de retrouver l'aquarium."
            }
        }
    }

    // MARK: - AlertRepository
    
    func getAlert(aquarium id: Int) async throws -> AlertData? {
        guard let dto = try await alertRemoteDataSource.fetchAlert(aquarium: id) else { return nil }

        let aquarium = try aquariumLocalDataSource.getAquarium(byId: id)
        upsertAlert(on: aquarium, with: dto)
        aquariumLocalDataSource.save()
        return try alertLocalDataSource.getAlert(aquarium: id)
    }
    
    func updateAlert(alert: AlertRequestDTO) async throws {
        guard let aquarium = try? aquariumLocalDataSource.getAquarium(byId: alert.aquariumId) else {
            throw Error.aquariumNotFound
        }
        
        let dto = try await alertRemoteDataSource.updateAlert(alert: alert)

        upsertAlert(on: aquarium, with: dto)
        aquariumLocalDataSource.save()
    }

    private func upsertAlert(on aquarium: AquariumData, with dto: AlertDTO) {
        if let existingAlert = aquarium.alert {
            existingAlert.modelId = dto.id
            existingAlert.aquariumId = dto.aquariumId
            existingAlert.phMin = dto.phMin
            existingAlert.phMax = dto.phMax
            existingAlert.tdsMin = dto.tdsMin
            existingAlert.tdsMax = dto.tdsMax
            existingAlert.turbidityMin = dto.turbidityMin
            existingAlert.turbidityMax = dto.turbidityMax
            existingAlert.temperatureMin = dto.temperatureMin
            existingAlert.temperatureMax = dto.temperatureMax
            return
        }

        aquarium.alert = AlertAdapter.convert(from: dto)
    }
}

extension InjectedValues {

    @Inject public var alertRepository: AlertRepositoryProtocol = AlertRepository()
}
