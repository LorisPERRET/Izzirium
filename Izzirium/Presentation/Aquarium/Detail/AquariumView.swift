//
//  AquariumView.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SwiftUI

struct AquariumView<ViewModel>: View where ViewModel: AquariumViewModelProtocol {

    // MARK: - Properties

    @EnvironmentObject private var pathNavigator: ZZPathNavigator
    @StateObject private var viewModel: ViewModel
    
    let columns = [
        GridItem(spacing: MagicUnit.mu100.rawValue),
        GridItem(spacing: MagicUnit.mu100.rawValue)
    ]
    
    // MARK: - Body

    var body: some View {
        if let last = viewModel.aquarium.logs.last {
            content(lastMeasure: last)
        } else {
            EmptyView()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Methods
    
    private func content(lastMeasure measure: AquariumUI.LogUI) -> some View {
        VStack {
            ZZText("Dernière mesure faite le \(measure.date.formatted())")
            
            LazyVGrid(columns: columns, spacing: MagicUnit.mu100.rawValue) {
                GridRow {
                    cell(for: .ph)
                    cell(for: .tds)
                }
                
                GridRow {
                    cell(for: .turbidity)
                    cell(for: .temperature)
                }
            }
        }
        .padding(.mu100)
        .zzNavigationTitle(title: viewModel.aquarium.name)
        .navigationBarTitleDisplayMode(.large)
        .expand(alignment: .top)
    }

    private func cell(for type: AquariumViewModel.LogType) -> some View {
        let values = viewModel.getMesures(for: type)
        return ZZCard {
            ZZText(type.title + " :")
            ZZText("\(values.last?.value ?? 0)")
        } action: {
            pathNavigator.append(AnyZZScreen(
                AquariumScreen.sensor(type.title, values)
            ))
        }
        .zzShadow(.medium)
    }
}

#if DEBUG

#Preview {
    AquariumView(
        viewModel: FakeAquariumViewModel()
    )
}

#endif
