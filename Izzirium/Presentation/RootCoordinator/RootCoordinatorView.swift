//
//  RootCoordinatorView.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SKState
import SwiftUI

struct RootCoordinatorView<ViewModel>: View where ViewModel: RootCoordinatorViewModelProtocol {

    // MARK: - Properties

    @Environment(\.scenePhase) var scenePhase

    @StateObject private var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.loginState {
            case .loading:
                ProgressView()

            case .loaded(let state):
                contentView(state)
                    .environment(\.loginState, state)

            case .failed:
                EmptyView()
            }
        }
        .task {
            await viewModel.fetchLoginState()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    // MARK: - Methods

    @ViewBuilder
    private func contentView(_ state: LoginState) -> some View {
        switch state {
        case .logged, .withoutLogin:
            AquariumListView(viewModel: AquariumListViewModel())
        case .unlogged:
            EmptyView()
        }
    }
}

#if DEBUG

#Preview("Loading") {
    RootCoordinatorView(
        viewModel: FakeRootCoordinatorViewModel(
            withLoginState: .loading
        )
    )
}

#Preview("Error") {
    RootCoordinatorView(
        viewModel: FakeRootCoordinatorViewModel(
            withLoginState: .failed(NSError(domain: "Domain", code: -1, userInfo: ["UserInfoKey": "Any"]))
        )
    )
}

#Preview("Loaded - Logged") {
    RootCoordinatorView(
        viewModel: FakeRootCoordinatorViewModel(
            withLoginState: .loaded(.logged)
        )
    )
}

#Preview("Loaded - Logged") {
    RootCoordinatorView(
        viewModel: FakeRootCoordinatorViewModel(
            withLoginState: .loaded(.logged)
        )
    )
}

#Preview("Loaded - Logged") {
    RootCoordinatorView(
        viewModel: FakeRootCoordinatorViewModel(
            withLoginState: .loaded(.logged)
        )
    )
}

#Preview("Loaded - Unlogged") {
    RootCoordinatorView(
        viewModel: FakeRootCoordinatorViewModel(
            withLoginState: .loaded(.unlogged)
        )
    )
}

#endif
