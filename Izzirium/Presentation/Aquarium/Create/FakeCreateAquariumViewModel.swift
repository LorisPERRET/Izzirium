//
//  FakeCreateAquariumViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

#if DEBUG

import Foundation
import SKState

final class FakeCreateAquariumViewModel: CreateAquariumViewModelProtocol {

    // MARK: - Properties

    @Published var aquariumName: String = ""
    @Published private(set) var requestState: SKDataRequestState<String> = .idle
    var requestStatePublisher: SKDataRequestStatePublisher<String> {
        $requestState
    }

    // MARK: - Init

    // MARK: - CreateAquariumViewModelProtocol

    func createAquarium() async {
        requestState = .success("")
    }
}

#endif
