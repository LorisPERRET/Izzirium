//
//  UpdateAlertUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol UpdateAlertUseCaseProtocol: Sendable {

    func perform(alert: AlertBody) async throws
}

@InjectedMember(\.alertRepository)
final class UpdateAlertUseCase: UpdateAlertUseCaseProtocol {

    // MARK: UpdateAlertUseCaseProtocol

    func perform(alert: AlertBody) async throws {
        try await alertRepository.updateAlert(alert: alert)
    }
}

extension InjectedValues {

    @Inject public var updateAlertUseCase: UpdateAlertUseCaseProtocol = UpdateAlertUseCase()
}
