//
//  CreateAquariumUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol CreateAquariumUseCaseProtocol: Sendable {

    func perform(name: String) async throws -> Aquarium
}

@InjectedMember(\.aquariumRepository)
final class CreateAquariumUseCase: CreateAquariumUseCaseProtocol {

    // MARK: CreateAquariumUseCaseProtocol

    func perform(name: String) async throws -> Aquarium {
        try await aquariumRepository.createAquarium(name: name)
    }
}

extension InjectedValues {

    @Inject public var createAquariumUseCase: CreateAquariumUseCaseProtocol = CreateAquariumUseCase()
}
