//
//  ConfigurationView.swift
//  Izzirium
//
//  Created by Loris Perret on 24/03/2026.
//

import DesignSystem
import SwiftUI

struct ConfigurationView<ViewModel>: View where ViewModel: ConfigurationViewModelProtocol {
    
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var pathNavigator: ZZPathNavigator

    @State private var hasBeenSubmitted = false
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case ssid
        case password
    }

    private let ssidRules = [
        StringValidationRule.isNotBlankOrEmpty
    ]
    
    private let passwordRules = [
        StringValidationRule.isNotBlankOrEmpty
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: MagicUnit.mu200.rawValue) {
                wifi
                devices
            }
            .padding(.mu100)
        }
        .navigationTitle("Configuration")
        .toolbar {
            Button("Scanner") {
                viewModel.startScan()
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.startScan()
        }
        .errorToast(publisher: viewModel.bleRequestStatePublisher)
        .errorToast(publisher: viewModel.connectRequestStatePublisher)
        .onReceive(viewModel.connectRequestStatePublisher) { requestState in
            guard case .success = requestState else { return }
            pathNavigator.popToRoot()
        }
        .onScrollPhaseChange { _, _ in
            focusedField = nil
        }
    }
    
    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    private var wifi: some View {
        VStack {
            ZZText("Configuration Wi-Fi", foregroundColor: .neutralLow)
                .padding(.bottom, .mu100)

            ZZTextField(
                value: $viewModel.wifiSSID,
                hasBeenSubmitted: hasBeenSubmitted,
                type: .text,
                label: "SSID",
                rules: ssidRules,
                validationStyle: .submit,
                validationCheckmarkAlignment: .none
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($focusedField, equals: .ssid)

            ZZTextField(
                value: $viewModel.wifiPassword,
                hasBeenSubmitted: hasBeenSubmitted,
                type: .password,
                label: "Mot de passe",
                rules: passwordRules,
                validationStyle: .submit,
                validationCheckmarkAlignment: .none
            )
            .focused($focusedField, equals: .password)
        }
    }

    private var devices: some View {
        VStack {
            ZZText("Appareils trouvés", foregroundColor: .neutralLow)
                .padding(.bottom, .mu100)

            if viewModel.discoveredDevices.isEmpty {
                ZZText("Aucun appareil détécté", frameAlignment: .center)
                    .padding(.vertical, .mu200)
            } else {
                ForEach(viewModel.discoveredDevices) { device in
                    ZZAsyncButton(title: device.name, theme: .secondary) {
                        hasBeenSubmitted = true
                        focusedField = nil
                        if ssidRules.allSatisfy({ $0.validate(viewModel.wifiSSID) }),
                           passwordRules.allSatisfy({ $0.validate(viewModel.wifiPassword) }) {
                            await viewModel.connect(to: device)
                        }
                    }
                }
            }
        }
    }
}
