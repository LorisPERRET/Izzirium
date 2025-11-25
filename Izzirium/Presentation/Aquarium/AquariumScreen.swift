//
//  AquariumScreen.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SwiftUI

enum AquariumScreen: ZZScreenProtocol {

    case detail(AquariumUI)
    case list
    case sensor(LogType, [ChartValue])

    // MARK: ScreenProtocol

    var id: String {
        switch self {
        case .detail(let aquarium):
            "detail_\(aquarium.id)"

        case .list:
            "list"
            
        case .sensor(let type, _):
            "sensor_\(type.title)"
        }
    }

    @ViewBuilder
    var screen: some View {
        switch self {
        case let .detail(aquarium):
            AquariumView(viewModel: AquariumViewModel(aquarium: aquarium))

        case .list:
            AquariumListView(viewModel: AquariumListViewModel())
            
        case .sensor(let type, let values):
            SensorView(type: type, values: values)
        }
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
