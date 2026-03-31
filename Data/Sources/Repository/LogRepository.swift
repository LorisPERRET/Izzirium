//
//  LogRepository.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
public protocol LogRepositoryProtocol: Sendable {

    func getLogs(aquarium id: Int) async throws -> [LogData]
}

@InjectedMember(\.aquariumLocalDataSource)
@InjectedMember(\.logLocalDataSource)
@InjectedMember(\.logRemoteDataSource)
final class LogRepository: LogRepositoryProtocol {
    
    // MARK: - LogRepository
    
    func getLogs(aquarium id: Int) async throws -> [LogData] {
        let dtos = try await logRemoteDataSource.fetchLogs(aquarium: id)
        let aquarium = try aquariumLocalDataSource.getAquarium(byId: id)
        aquarium.logs.append(contentsOf: dtos.map(LogAdapter.convert))
        aquariumLocalDataSource.save()
        return try logLocalDataSource.getLogs(aquarium: id)
    }
}

extension InjectedValues {

    @Inject public var logRepository: LogRepositoryProtocol = LogRepository()
}
