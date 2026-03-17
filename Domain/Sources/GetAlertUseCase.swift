//
//  GetAlertUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol GetAlertUseCaseProtocol: Sendable {

    func perform(aquarium id: Int) async throws -> Alert?
}

@InjectedMember(\.alertRepository)
final class GetAlertUseCase: GetAlertUseCaseProtocol {

    // MARK: GetAlertUseCaseProtocol

    func perform(aquarium id: Int) async throws -> Alert? {
        try await alertRepository.getAlert(aquarium: id)
    }
}

extension InjectedValues {

    @Inject public var getAlertUseCase: GetAlertUseCaseProtocol = GetAlertUseCase()
}
