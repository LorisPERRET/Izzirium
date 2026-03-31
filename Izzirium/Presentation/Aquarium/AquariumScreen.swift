//
//  AquariumScreen.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SwiftUI

enum AquariumScreen: ZZScreenProtocol {

    case detail(AquariumUI, () -> Void)
    case settings(AquariumUI, AlertUI?, () async -> Void)
    case list
    case sensor(SensorType, [ChartValue], AlertUI?)

    // MARK: ScreenProtocol

    var id: String {
        switch self {
        case .detail(let aquarium, _):
            "detail_\(aquarium.id)"

        case .settings:
            "settings"

        case .list:
            "list"
            
        case .sensor(let type, _, _):
            "sensor_\(type.title)"
        }
    }

    @ViewBuilder
    var screen: some View {
        switch self {
        case let .detail(aquarium, callback):
            AquariumView(viewModel: AquariumViewModel(aquarium: aquarium), reloadFavorite: callback)

        case let .settings(aquarium, alert, callback):
            SensorSettingsView(
                viewModel: SensorSettingsViewModel(
                    aquariumId: aquarium.id,
                    aquariumName: aquarium.name,
                    alert: alert,
                    onSuccess: callback
                )
            )

        case .list:
            AquariumListView(viewModel: AquariumListViewModel())
            
        case let .sensor(type, values, alert):
            SensorView(type: type, values: values, alert: alert)
        }
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
