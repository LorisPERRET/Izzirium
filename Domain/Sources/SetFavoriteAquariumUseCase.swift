//
//  SetFavoriteAquariumUseCase.swift
//  Domain
//
//  Created by Loris Perret on 24/11/2025.
//

import Data
import Foundation
import SKDependencyInjection

@MainActor
public protocol SetFavoriteAquariumUseCaseProtocol: Sendable {

    func perform(aquarium: Int?) async
}

@InjectedMember(\.aquariumRepository)
final class SetFavoriteAquariumUseCase: SetFavoriteAquariumUseCaseProtocol {

    // MARK: SetFavoriteAquariumUseCaseProtocol

    func perform(aquarium: Int?) async {
        await aquariumRepository.setFavorite(aquarium: aquarium)
    }
}

extension InjectedValues {

    @Inject public var setFavoriteAquariumUseCase: SetFavoriteAquariumUseCaseProtocol = SetFavoriteAquariumUseCase()
}
