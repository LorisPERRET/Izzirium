//
//  GetLogsUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol GetLogsUseCaseProtocol: Sendable {

    func perform(aquarium id: Int) async throws -> [Log]
}

@InjectedMember(\.logRepository)
final class GetLogsUseCase: GetLogsUseCaseProtocol {

    // MARK: GetLogsUseCaseProtocol

    func perform(aquarium id: Int) async throws -> [Log] {
        try await logRepository.getLogs(aquarium: id)
    }
}

extension InjectedValues {

    @Inject public var getLogsUseCase: GetLogsUseCaseProtocol = GetLogsUseCase()
}
