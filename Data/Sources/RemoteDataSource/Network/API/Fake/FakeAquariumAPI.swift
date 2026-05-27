//
//  FakeAquariumAPI.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation

#if API_MOCK

import Foundation
import PapyrusAlamofire

final class FakeAquariumAPI: AquariumAPI {

    // MARK: - Properties

    let sleepTime: UInt64 = 2_000_000_000

    // MARK: - AquariumAPI
    
    func getAquariums() async throws -> [AquariumDTO] {
        AquariumDTO.Fake.list
    }

    func getPrediction(aquarium id: Int) async throws -> PredictResponseDTO {
        PredictResponseDTO(result: "Stable sur les prochaines 24 heures.")
    }

    func createAquarium(name: String) async throws -> AquariumDTO {
        AquariumDTO(id: 0, name: name, secretSensorId: "azertyuiop")
    }

    func deleteAquarium(aquarium id: Int) async throws {}
}

#endif
