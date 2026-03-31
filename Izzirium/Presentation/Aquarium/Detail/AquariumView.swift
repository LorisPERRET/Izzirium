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
    let reloadFavorite: () -> Void
    
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

            case .loaded(let datas):
                content(logs: datas.logs, alert: datas.alert)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    await viewModel.setFavorite()
                                    reloadFavorite()
                                }
                            } label: {
                                Image(systemName: viewModel.favorite == viewModel.aquarium.id ? "star.fill" : "star")
                                    .renderingMode(.template)
                                    .foregroundStyle(viewModel.favorite == viewModel.aquarium.id ? Color.warningLow : Color.neutralMedium)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                pathNavigator.append(
                                    AnyZZScreen(
                                        AquariumScreen.settings(
                                            viewModel.aquarium,
                                            viewModel.aquarium.alert
                                        ) {
                                            await viewModel.getDatas()
                                        }
                                    )
                                )
                            } label: {
                                Image(systemName: "gear")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.primaryMedium)
                            }
                        }
                    }
                    .alert(
                        "Un autre favori existe, en confirmant vous allez le supprimer.",
                        isPresented: $viewModel.confirmFavoritePopup
                    ) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.confirmFavorite()
                                reloadFavorite()
                            }
                        } label: {
                            Text("Confirmer")
                        }
                        
                        Button("Annuler", role: .cancel) {}
                    }
                
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
            await viewModel.getDatas()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel, reloadFavorite: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel())
        self.reloadFavorite = reloadFavorite
    }
    
    // MARK: - Methods
    
    private func content(
        logs: [AquariumUI.LogUI],
        alert: AlertUI?
    ) -> some View {
        VStack(spacing: MagicUnit.mu100.rawValue) {
            if let last = logs.last {
                List {
                    ZZText("Dernière mesure faite le \(last.date.formatted())")
                        .listRowSeparator(.hidden)
                    
                    ForEach(SensorType.allCases, id: \.self) { type in
                        cell(for: type, logs: logs, alert: alert)
                            .listRowSeparator(.hidden)
                    }
                }
                .listRowSeparator(.hidden)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .contentMargins(0)
                .refreshable {
                    Task {
                        await viewModel.getDatas()
                    }
                }
            } else {
                ZZText(
                    "Aucune valeurs remontées",
                    frameAlignment: .center
                )
                .expand(alignment: .center)
            }
        }
        .expand(alignment: .top)
    }

    private func cell(
        for type: SensorType,
        logs: [AquariumUI.LogUI],
        alert: AlertUI?
    ) -> some View {
        let values = viewModel.getValues(for: type, logs: logs)
        let value = values.last?.value
        let alertValues = alert?.getValue(for: type)
        return ZZCard {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ZZText(type.title, font: .h6)
                    
                    if let (min, max) = alertValues, let value {
                        sensorStateIcon(min: min, max: max, value: value)
                    }
                }
                
                if let value = values.last?.value {
                    sensorValue(alertValues: alertValues, value: value, type: type)
                    
                    if let (min, max) = alertValues {
                        sensorAlertInfo(min: min, max: max, value: value, type: type)
                    }
                } else {
                    ZZText("Aucune valeur remontées", font: .textS)
                }
            }
        } action: {
            pathNavigator.append(AnyZZScreen(
                AquariumScreen.sensor(type, values, alert)
            ))
        }
        .background(
            RoundedRectangle(cornerRadius: RadiusStyle.medium.rawValue)
                .fill(Color.lightHightest)
                .zzShadow(.small)
        )
    }
    
    private func sensorStateIcon(min: Float, max: Float, value: Float) -> some View {
        Image(systemName: isWarning(min: min, max: max, value: value) ? "exclamationmark.triangle" : "checkmark.circle")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(isWarning(min: min, max: max, value: value) ? Color.warningMedium : Color.successMedium)
            .frame(
                width: MagicUnit.mu150.rawValue,
                height: MagicUnit.mu150.rawValue
            )
            .padding(.mu075)
            .padding(.leading, .mu0125)
            .padding(.bottom, .mu0125)
            .background(alignment: .center) {
                Circle()
                    .fill(isWarning(min: min, max: max, value: value) ? Color.warningLowest : Color.successLowest)
            }
    }
    
    private func sensorAlertInfo(min: Float, max: Float, value: Float, type: SensorType) -> some View {
        VStack {
            Divider()
            
            HStack(spacing: MagicUnit.mu050.rawValue) {
                Image(systemName: "exclamationmark.triangle")
                    .renderingMode(.template)
                    .foregroundStyle(isWarning(min: min, max: max, value: value) ? Color.dangerHight : Color.neutralLow)
                ZZText(
                    "Alertes: min \(min)\(type.unitLabel ?? "") • max \(max)\(type.unitLabel ?? "")",
                    font: isWarning(min: min, max: max, value: value) ? .textSemiBoldXS : .textXS,
                    foregroundColor: isWarning(min: min, max: max, value: value) ? Color.dangerHight : Color.neutralLow
                )
            }
            .padding(.top, .mu050)
        }
    }
    
    private func sensorValue(alertValues: (Float, Float)?, value: Float, type: SensorType) -> some View {
        HStack(alignment: .bottom, spacing: MagicUnit.mu025.rawValue) {
            ZZText(
                "\(value)",
                font: FontStyle(
                    fontConvertible: ZZFonts.Poppins.semiBold,
                    size: 36,
                    lineHeight: 36,
                    textStyle: .body
                ),
                foregroundColor: {
                    if let (min, max) = alertValues {
                        if isWarning(min: min, max: max, value: value) {
                            return Color.warningMedium
                        } else {
                            return Color.successMedium
                        }
                    } else {
                        return Color.neutralMedium
                    }
                }(),
                maxWidth: false
            )
            if let unitLabel = type.unitLabel {
                ZZText(
                    "\(unitLabel)",
                    font: .textL,
                    foregroundColor: .gray,
                    maxWidth: false
                )
                .padding(.bottom, .mu025)
            }
        }
    }
    
    private func isWarning(min: Float, max: Float, value: Float) -> Bool {
        return !(min <= value && value <= max)
    }
}

#if DEBUG

import Data

#Preview("Loading") {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .loading,
            aquarium: AquariumUI.Fake.preview,
            favorite: nil
        )
    ) {}
}

#Preview("Error") {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .failed(DataError.network),
            aquarium: AquariumUI.Fake.preview,
            favorite: nil
        )
    ) {}
}

#Preview("Empty") {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .loaded(DataResponse(logs: [], alert: nil)),
            aquarium: AquariumUI.Fake.preview,
            favorite: nil
        )
    ) {}
}

#Preview("Logs, Alert") {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .loaded(
                DataResponse(
                    logs: [
                        AquariumUI.LogUI(
                            date: Date(),
                            ph: 7,
                            tds: 300,
                            turbidity: 10,
                            temperature: 20
                        )
                    ],
                    alert: AlertUI(
                        phMin: 6.5,
                        phMax: 7.5,
                        tdsMin: 200,
                        tdsMax: 400,
                        turbidityMin: 0,
                        turbidityMax: 5,
                        temperatureMin: 22,
                        temperatureMax: 26
                    )
                )
                
            ),
            aquarium: AquariumUI.Fake.preview,
            favorite: nil
        )
    ) {}
}

#Preview("Logs, Alert") {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .loaded(
                DataResponse(
                    logs: [
                        AquariumUI.LogUI(
                            date: Date(),
                            ph: 7,
                            tds: 300,
                            turbidity: 10,
                            temperature: 20
                        )
                    ],
                    alert: AlertUI(
                        phMin: 6.5,
                        phMax: 7.5,
                        tdsMin: 200,
                        tdsMax: 400,
                        turbidityMin: 0,
                        turbidityMax: 5,
                        temperatureMin: 22,
                        temperatureMax: 26
                    )
                )
                
            ),
            aquarium: AquariumUI.Fake.preview,
            favorite: 0
        )
    ) {}
}

#Preview("Logs, no Alert") {
    AquariumView(
        viewModel: FakeAquariumViewModel(
            withState: .loaded(
                DataResponse(
                    logs: [
                        AquariumUI.LogUI(
                            date: Date(),
                            ph: 1,
                            tds: 1,
                            turbidity: 1,
                            temperature: 1
                        )
                    ],
                    alert: nil
                )
                
            ),
            aquarium: AquariumUI.Fake.preview,
            favorite: 1
        )
    ) {}
}

#endif
