//
//  AquariumListView.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
import SwiftUI

struct AquariumListView<ViewModel>: View where ViewModel: AquariumListViewModelProtocol {

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel
    @State private var navigationPath = [AnyZZScreen]()
    
    // MARK: - Body

    var body: some View {
        ZZNavigationView(path: $navigationPath) {
            Group {
                switch viewModel.dataState {
                case .loading:
                    ProgressView()

                case .loaded(let list):
                    content(aquariums: list)
                    
                case .failed(let error):
                    EmptyView()
                }
            }
            .zzNavigationDestinationForAnyZZScreen()
        }
        .task {
            await viewModel.fetchAquariums()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Methods

    @ViewBuilder
    private func content(aquariums: [AquariumUI]) -> some View {
        if aquariums.isEmpty {
            EmptyView()
        } else {
            ScrollView {
                VStack(spacing: MagicUnit.mu100.rawValue) {
                    ForEach(aquariums) { aquarium in
                        AquariumCellView(item: aquarium)
                    }
                }
                .padding(.mu100)
            }
            .zzNavigationTitle(title: "Mes Aquariums")
        }
    }
}

#if DEBUG

#Preview("Loaded") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withState: .loaded(AquariumUI.Fake.list)
        )
    )
}

#Preview("Loaded - Empty") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withState: .loaded([])
        )
    )
}

#Preview("Loading") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withState: .loading
        )
    )
}

#Preview("Error") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withState: .failed(NSError(domain: "Domain", code: -1, userInfo: ["UserInfoKey": "Any"]))
        )
    )
}

#endif
