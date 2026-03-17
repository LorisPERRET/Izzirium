//
//  FavoriteCellView.swift
//  Izzirium
//
//  Created by Loris Perret on 13/11/2025.
//

import DesignSystem
import SwiftUI

struct FavoriteCellView<ViewModel>: View where ViewModel: FavoriteCellViewModelProtocol {

    // MARK: - Properties

    @EnvironmentObject private var pathNavigator: ZZPathNavigator
    @StateObject private var viewModel: ViewModel
    
    private let columns = [
        GridItem(spacing: MagicUnit.mu100.rawValue),
        GridItem(spacing: MagicUnit.mu100.rawValue)
    ]

    // MARK: - Body

    var body: some View {
        ZZCard(
            bodyContent: {
                VStack {
                    HStack {
                        ZZText(
                            "\(viewModel.aquarium.name)",
                            font: .h6,
                            foregroundColor: .white
                        )
                        
                        Image(systemName: "chevron.right")
                            .renderingMode(.template)
                            .foregroundStyle(Color.white)
                    }
                    
                    switch viewModel.dataState {
                    case .loading:
                        ProgressView()
                            .tint(.white)
                            .padding(.vertical, .mu200)
                    case .failed(let error):
                        ZZText(
                            error.localizedDescription,
                            foregroundColor: .white
                        )
                        .padding(.vertical, .mu200)
                    case .loaded(let values):
                        logs(values)
                    }
                }
                .padding(.vertical, .mu050)
            },
            action: {
                pathNavigator.append(
                    AnyZZScreen(AquariumScreen.detail(viewModel.aquarium))
                )
            },
            backgroundColor: .primaryMedium
        )
        .zzShadow(.small)
    }
    
    // MARK: - Init
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    // MARK: - Methods
    
    @ViewBuilder
    private func logs(_ logs: [AquariumUI.LogUI]) -> some View {
        if logs.isEmpty {
            ZZText(
                "Aucune valeur remontée pour le moment.",
                foregroundColor: .white,
                frameAlignment: .center
            )
            .padding(.vertical, .mu200)
        } else {
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
        }
    }
    
    private func cell(for type: SensorType, logs: [AquariumUI.LogUI]) -> some View {
        let values = logs.getValues(for: type)
        
        return ZZCard(
            bodyContent: {
                VStack(alignment: .center) {
                    ZZText(
                        type.title,
                        font: .textS,
                        foregroundColor: .white,
                        frameAlignment: .center
                    )
                    HStack(spacing: MagicUnit.mu025.rawValue) {
                        ZZText(
                            "\(values.last?.value ?? 0)",
                            font: .textSemiBoldBase,
                            foregroundColor: .white,
                            maxWidth: false
                        )
                        
                        if let unitLabel = type.unitLabel {
                            ZZText(
                                "\(unitLabel)",
                                font: .textS,
                                foregroundColor: .white,
                                maxWidth: false
                            )
                        }
                    }
                }
            },
            action: nil,
            backgroundColor: Color.primaryLow
        )
        .zzShadow(.medium)
    }
}

#if DEBUG

import Data

#Preview("loading") {
    FavoriteCellView(
        viewModel: FakeFavoriteCellViewModel(
            withState: .loading, aquarium: AquariumUI.Fake.preview
        )
    )
}

#Preview("empty") {
    FavoriteCellView(
        viewModel: FakeFavoriteCellViewModel(
            withState: .loaded([]), aquarium: AquariumUI.Fake.preview
        )
    )
}

#Preview("failed") {
    FavoriteCellView(
        viewModel: FakeFavoriteCellViewModel(
            withState: .failed(DataError.network),
            aquarium: AquariumUI.Fake.preview
        )
    )
}

#Preview("loaded") {
    FavoriteCellView(
        viewModel: FakeFavoriteCellViewModel(
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
