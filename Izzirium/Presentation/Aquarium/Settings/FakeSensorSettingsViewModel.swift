//
//  FakeSensorSettingsViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

#if DEBUG

import Foundation
import SKState

final class FakeSensorSettingsViewModel: SensorSettingsViewModelProtocol {

    // MARK: - Properties
    
    let aquariumId: Int = 0
    @Published var aquariumName = "Aquarium Name"
    @Published var alert: AlertUI = .init(
        phMin: 6.5,
        phMax: 7.5,
        tdsMin: 200,
        tdsMax: 400,
        turbidityMin: 0,
        turbidityMax: 5,
        temperatureMin: 22,
        temperatureMax: 26
    )
    @Published private(set) var dataRequestState: SKDataRequestState<Void> = .idle
    var dataRequestStatePublisher: SKDataRequestStatePublisher<Void> {
        $dataRequestState
    }

    // MARK: - SensorSettingsViewModelProtocol
    
    func saveChange() async {}
}

#endif
