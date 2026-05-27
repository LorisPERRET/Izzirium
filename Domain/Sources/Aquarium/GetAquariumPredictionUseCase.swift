//
//  GetAquariumPredictionUseCase.swift
//  Domain
//
//  Created by Codex on 27/05/2026.
//

import Data
import SKDependencyInjection

@MainActor
public protocol GetAquariumPredictionUseCaseProtocol: Sendable {

    func perform(aquarium id: Int) async throws -> String?
}

@InjectedMember(\.aquariumRepository)
final class GetAquariumPredictionUseCase: GetAquariumPredictionUseCaseProtocol {

    func perform(aquarium id: Int) async throws -> String? {
        try await aquariumRepository.getPrediction(aquarium: id)
    }
}

extension InjectedValues {

    @Inject public var getAquariumPredictionUseCase: GetAquariumPredictionUseCaseProtocol = GetAquariumPredictionUseCase()
}
