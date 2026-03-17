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
                ZZText(
                    error.localizedDescription,
                    frameAlignment: .center
                )
            }
        }
        .zzNavigationTitle(title: viewModel.aquarium.name)
        .navigationBarTitleDisplayMode(.inline)
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
                    .padding(.mu100)
                
                List {
                    ForEach(SensorType.allCases, id: \.self) { type in
                        cell(for: type, logs: logs)
                            .listRowSeparator(.hidden)
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                
            } else {
                ZZText(
                    "Aucune valeurs remontées",
                    frameAlignment: .center
                )
                    .padding(.mu100)
            }
        }
        .expand(alignment: .top)
    }

    private func cell(for type: SensorType, logs: [AquariumUI.LogUI]) -> some View {
        let values = viewModel.getValues(for: type, logs: logs)
        return ZZCard {
            ZZText(type.title, font: .h6)
            
            HStack(alignment: .bottom, spacing: MagicUnit.mu025.rawValue) {
                ZZText(
                    "\(values.last?.value ?? 0)",
                    font: FontStyle(
                        fontConvertible: ZZFonts.Poppins.semiBold,
                        size: 36,
                        lineHeight: 36,
                        textStyle: .body
                    ),
                    maxWidth: false
                )
                if let unitLabel = type.unitLabel {
                    ZZText(
                        "\(unitLabel)",
                        font: .h6,
                        foregroundColor: .gray,
                        maxWidth: false
                    )
                    .padding(.bottom, .mu025)
                }
            }
            
            Divider()
            
            HStack(spacing: MagicUnit.mu050.rawValue) {
                Image(systemName: "exclamationmark.triangle")
                    .renderingMode(.template)
                    .foregroundStyle(Color.neutralLow)
                ZZText(
                    "Alertes: min \(0)\(type.unitLabel ?? "") • max \(0)\(type.unitLabel ?? "")",
                    font: .textXS,
                    foregroundColor: Color.neutralLow,
                    maxWidth: false
                )
            }
            
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
