//
//  ConfigurationView.swift
//  Izzirium
//
//  Created by Loris Perret on 24/03/2026.
//

import SwiftUI

struct ConfigurationView<ViewModel>: View where ViewModel: ConfigurationViewModelProtocol {
    
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                Section("Etat") {
                    Text(stateTitle)

                    if let connectedDevice = viewModel.connectedDevice {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Connecte a \(connectedDevice.name)")
                            Text(connectedDevice.deviceId)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                Section("Configuration Wi-Fi") {
                    TextField("SSID", text: $viewModel.wifiSSID)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    SecureField("Mot de passe", text: $viewModel.wifiPassword)

                    TextField("Sensor ID", text: $viewModel.sensorId)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Appareils trouves") {
                    if viewModel.discoveredDevices.isEmpty {
                        Text("Aucun appareil detecte pour le moment.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.discoveredDevices) { device in
                            Button {
                                viewModel.connect(to: device)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(device.name)
                                        Text(device.id)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("\(device.rssi) dBm")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("Connecter + envoyer")
                                            .font(.caption2)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Configuration BLE")
            .toolbar {
                Button("Scanner") {
                    viewModel.startScan()
                }
            }
            .onAppear {
                viewModel.startScan()
            }
        }
    }
    
    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
}

private extension ConfigurationView {

    var stateTitle: String {
        switch viewModel.pairingState {
        case .idle:
            "Bluetooth pret"
        case .checkingPermissions:
            "Verification du Bluetooth..."
        case .bluetoothUnavailable:
            "Bluetooth indisponible"
        case .scanning:
            "Scan en cours..."
        case .deviceFound(let devices):
            "\(devices.count) appareil(s) trouve(s)"
        case .connecting(let device):
            "Connexion a \(device.name)..."
        case .deviceReady(let device):
            "Connecte a \(device.name)"
        case .provisioning(let device):
            "Envoi du Wi-Fi a \(device.name)..."
        case .success:
            "Configuration terminee"
        case .failed(let error):
            error.localizedDescription
        }
    }
}
