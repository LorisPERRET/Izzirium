//
//  GetAquariumsUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol GetAquariumsUseCaseProtocol: Sendable {

    func perform() async throws -> [Aquarium]
}

@InjectedMember(\.aquariumRepository)
final class GetAquariumsUseCase: GetAquariumsUseCaseProtocol {

    // MARK: GetAquariumsUseCaseProtocol

    func perform() async throws -> [Aquarium] {
        try await aquariumRepository.getAquariums()
    }
}

extension InjectedValues {

    @Inject public var getAquariumsUseCase: GetAquariumsUseCaseProtocol = GetAquariumsUseCase()
}
