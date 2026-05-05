//
//  DeleteAquariumUseCase.swift
//  Domain
//
//  Created by Loris Perret on 05/05/2026.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol DeleteAquariumUseCaseProtocol: Sendable {

    func perform(id: Int) async throws
}

@InjectedMember(\.aquariumRepository)
final class DeleteAquariumUseCase: DeleteAquariumUseCaseProtocol {

    // MARK: DeleteAquariumUseCaseProtocol

    func perform(id: Int) async throws {
        try await aquariumRepository.deleteAquarium(id: id)
    }
}

extension InjectedValues {

    @Inject public var deleteAquariumUseCase: DeleteAquariumUseCaseProtocol = DeleteAquariumUseCase()
}
