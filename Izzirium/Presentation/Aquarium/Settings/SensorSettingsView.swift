//
//  SensorSettingsView.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SwiftUI

struct SensorSettingsView<ViewModel>: View where ViewModel: SensorSettingsViewModelProtocol {

    // MARK: - Properties

    @EnvironmentObject private var pathNavigator: ZZPathNavigator
    @StateObject private var viewModel: ViewModel
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case aquariumName
        case min(SensorType)
        case max(SensorType)
    }
    
    // MARK: - Body

    var body: some View {
        List {
            ZZTextField(
                value: $viewModel.aquariumName,
                hasBeenSubmitted: false,
                type: .text,
                label: nil
            )
            .focused($focusedField, equals: .aquariumName)
            
            ForEach(SensorType.allCases, id: \.self) { type in
                cell(for: type)
                    .listRowSeparator(.hidden)
            }
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .contentMargins(0)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
        .toolbar {
            Button {
                Task {
                    await viewModel.saveChange()
                }
            } label: {
                Image(systemName: "checkmark")
                    .renderingMode(.template)
                    .foregroundStyle(Color.primaryMedium)
            }
        }
        .errorToast(publisher: viewModel.dataRequestStatePublisher)
        .onReceive(viewModel.dataRequestStatePublisher) { requestState in
            guard case .success = requestState else { return }
            pathNavigator.pop()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Methods

    private func cell(for type: SensorType) -> some View {
        let values = viewModel.alert.getValue(for: type)
        
        return ZZCard(
            bodyContent: {
                ZZText(type.title, font: .h6)
                
                field(
                    title: "Seuil minimum d'alerte",
                    value: values.min,
                    type: type,
                    focusedValue: .min(type)
                ) { newValue in
                    viewModel.alert.setValue(
                        for: type,
                        values: (min: newValue, max: values.max)
                    )
                }
                
                field(
                    title: "Seuil maximum d'alerte",
                    value: values.max,
                    type: type,
                    focusedValue: .max(type)
                ) { newValue in
                    viewModel.alert.setValue(
                        for: type,
                        values: (min: values.min, max: newValue)
                    )
                    
                }
            },
            action: nil
        )
        .zzShadow(.small)
    }
    
    private func field(title: String, value: Float?, type: SensorType, focusedValue: Field, onChange: @escaping (Float?) -> Void) -> some View {
        VStack {
            ZZText(title, font: .textS)
            
            HStack {
                ZZTextField(
                    value: Binding<String>(
                        get: {
                            if let value {
                                "\(value)"
                            } else {
                                ""
                            }
                        },
                        set: { newValue in
                            onChange(Float(newValue))
                        }
                    ),
                    hasBeenSubmitted: false,
                    type: .numeric,
                    label: nil
                )
                .focused($focusedField, equals: focusedValue)
                if let label = type.unitLabel {
                    ZZText(
                        label,
                        font: .textS,
                        maxWidth: false
                    )
                }
            }
        }
    }
}

#if DEBUG

#Preview {
    SensorSettingsView(
        viewModel: FakeSensorSettingsViewModel()
    )
}

#endif
