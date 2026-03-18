//
//  GetFavoriteAquariumUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol GetFavoriteAquariumUseCaseProtocol: Sendable {

    func perform() async -> Aquarium?
}

@InjectedMember(\.aquariumRepository)
final class GetFavoriteAquariumUseCase: GetFavoriteAquariumUseCaseProtocol {

    // MARK: GetFavoriteAquariumUseCaseProtocol

    func perform() async -> Aquarium? {
        await aquariumRepository.getFavoriteAquarium()
    }
}

extension InjectedValues {

    @Inject public var getFavoriteAquariumUseCase: GetFavoriteAquariumUseCaseProtocol = GetFavoriteAquariumUseCase()
}
