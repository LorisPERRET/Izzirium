//
//  CreateAquariumViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Domain
import Foundation
import Kastor
import SKDependencyInjection
import SKState

@MainActor
protocol CreateAquariumViewModelProtocol: ObservableObject {

    var aquariumName: String { get set }

    var requestState: SKDataRequestState<String> { get }
    var requestStatePublisher: SKDataRequestStatePublisher<String> { get }

    func createAquarium() async

}

@InjectedMember(\.createAquariumUseCase)
final class CreateAquariumViewModel: CreateAquariumViewModelProtocol {

    // MARK: - Properties

    @Published var aquariumName: String = ""
    @Published private(set) var requestState: SKDataRequestState<String> = .idle
    var requestStatePublisher: SKDataRequestStatePublisher<String> {
        $requestState
    }

    private let logger = Logger(category: CreateAquariumViewModel.self)

    // MARK: - CreateAquariumViewModelProtocol

    func createAquarium() async {
        do {
            requestState = .loading
            let created = try await createAquariumUseCase.perform(name: aquariumName)
            requestState = .success(created.secretSensorId)
        } catch {
            requestState = .error(error)
        }
    }
}
