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
        Group {
            switch viewModel.dataState {
            case .loading:
                ProgressView()

            case .loaded(let logs):
                content(logs: logs)
                
            case .failed(let error):
                EmptyView()
            }
        }
        .zzNavigationTitle(title: viewModel.aquarium.name)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.getLogs()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Methods
    
    private func content(logs: [AquariumUI.LogUI]) -> some View {
        VStack {
            if let last = logs.last {
                ZZText("Dernière mesure faite le \(last.date.formatted())")
                
                LazyVGrid(columns: columns, spacing: MagicUnit.mu100.rawValue) {
                    GridRow {
                        cell(for: .ph, logs: logs)
                        cell(for: .tds, logs: logs)
                    }
                    
                    GridRow {
                        cell(for: .turbidity, logs: logs)
                        cell(for: .temperature, logs: logs)
                    }
                }
            } else {
                ZZText("Aucune valeurs remontées")
            }
        }
        .padding(.mu100)
        .expand(alignment: .top)
    }

    private func cell(for type: LogType, logs: [AquariumUI.LogUI]) -> some View {
        let values = viewModel.getValues(for: type, logs: logs)
        return ZZCard {
            ZZText(type.title + " :")
            ZZText("\(values.last?.value ?? 0)")
        } action: {
            pathNavigator.append(AnyZZScreen(
                AquariumScreen.sensor(type, values)
            ))
        }
        .zzShadow(.medium)
    }
}

#if DEBUG

#Preview {
    AquariumView(
        viewModel: FakeAquariumViewModel(withState: .loading, aquarium: AquariumUI.Fake.preview)
    )
}

#Preview {
    AquariumView(
        viewModel: FakeAquariumViewModel(withState: .loaded([]), aquarium: AquariumUI.Fake.preview)
    )
}

#Preview {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .loaded(
                [
                    AquariumUI.LogUI.init(
                        date: Date(),
                        ph: 1,
                        tds: 1,
                        turbidity: 1,
                        temperature: 1
                    )
                ]
            ),
            aquarium: AquariumUI.Fake.preview
        )
    )
}

#endif
