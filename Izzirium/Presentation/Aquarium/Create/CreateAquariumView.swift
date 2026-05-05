//
//  CreateAquariumView.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SwiftUI

struct CreateAquariumView<ViewModel>: View where ViewModel: CreateAquariumViewModelProtocol {

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var pathNavigator: ZZPathNavigator

    @FocusState private var focused: Bool
    @State private var hasBeenSubmitted = false

    private let nameRules = [
        StringValidationRule.isNotBlankOrEmpty
    ]

    // MARK: - Body

    var body: some View {
        VStack {
            Spacer()
            
            ZZTextField(
                value: $viewModel.aquariumName,
                hasBeenSubmitted: hasBeenSubmitted,
                type: .text,
                label: "Nom de l'aquarium",
                rules: nameRules,
                validationStyle: .submit,
                validationCheckmarkAlignment: .none
            )
            .focused($focused)

            Spacer()

            ZZAsyncButton(
                title: "Suivant"
            ) {
                hasBeenSubmitted = true
                focused = false
                if nameRules.allSatisfy({ $0.validate(viewModel.aquariumName) }) {
                    await viewModel.createAquarium()
                }
            }

            Spacer()
        }
        .zzNavigationTitle(title: "Ajouter un aquarium")
        .padding(.mu100)
        .errorToast(publisher: viewModel.requestStatePublisher)
        .errorToast(publisher: viewModel.requestLocationStatePublisher)
        .onReceive(viewModel.requestStatePublisher) { requestState in
            guard case let .success(token) = requestState else { return }
            pathNavigator.append(AnyZZScreen(AquariumScreen.configure(token)))
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
}

#if DEBUG

import Data

#Preview {
    CreateAquariumView(
        viewModel: FakeCreateAquariumViewModel()
    )
}

#endif
