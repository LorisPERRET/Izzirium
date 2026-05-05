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
    
    @Published private(set) var requestLocationState: SKDataRequestState<Void> = .idle
    var requestLocationStatePublisher: SKDataRequestStatePublisher<Void> {
        $requestLocationState
    }

    // MARK: - Init

    // MARK: - CreateAquariumViewModelProtocol

    func createAquarium() async {
        requestState = .success("")
    }
    
    func requestLocation() {}
}

#endif
