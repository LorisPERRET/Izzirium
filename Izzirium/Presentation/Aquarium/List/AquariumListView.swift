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
    @State private var showDeletePopup = false
    @State private var deleteAquarium: AquariumUI?
    
    // MARK: - Body

    var body: some View {
        ZZNavigationView(path: $navigationPath) {
            content
                .zzNavigationDestinationForAnyZZScreen()
        }
        .task {
            await viewModel.fetchAquariums()
            await viewModel.fetchFavorite()
        }
    }

    // MARK: - Init

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Methods

    @ViewBuilder
    private var content: some View {
        if viewModel.dataListState.isLoading, viewModel.dataFavoriteState.isLoading {
            ProgressView()
        } else {
            List {
                Section("Favori") {
                    favorite
                        .padding(.bottom, .mu100)
                }
                .listRowSeparator(.hidden)
                
                Section("Mes aquariums") {
                    list
                        .listRowSeparator(.hidden)
                }
                .listRowSeparator(.hidden)
            }
            .zzNavigationTitle(title: "Izzirium")
            .navigationBarTitleDisplayMode(.large)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .contentMargins(0)
            .refreshable {
                await viewModel.fetchAquariums()
                await viewModel.fetchFavorite()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationPath.append(AnyZZScreen(AquariumScreen.create))
                    } label: {
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundStyle(Color.primaryMedium)
                    }
                }
            }
            .errorToast(publisher: viewModel.deleteRequestStatePublisher)
            .onReceive(viewModel.deleteRequestStatePublisher) { result in
                guard case .success = result else { return }
                Task {
                    await viewModel.fetchAquariums()
                    await viewModel.fetchFavorite()
                    showDeletePopup = false
                }
            }
            .applyIfLet(deleteAquarium) { view, aquarium in
                view
                    .zzPopup(
                        isPresented: $showDeletePopup,
                        title: "Voulez vous supprimez l'aquarium : \(aquarium.name)",
                        buttons: {
                            [
                                ActionButton(title: "Annuler", type: .cancel, action: {
                                    showDeletePopup = false
                                }),
                                ActionButton(title: "Confirmer", type: .destructive, action: {
                                    Task {
                                        await viewModel.deleteAquarium(id: aquarium.id)
                                    }
                                })
                            ]
                        }()
                    )
            }
        }
    }
    
    @ViewBuilder
    private var favorite: some View {
        switch viewModel.dataFavoriteState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
        case .loaded(let aquarium):
            if let aquarium {
                FavoriteCellView(
                    viewModel: FavoriteCellViewModel(aquarium: aquarium)
                ) {
                    Task {
                        await viewModel.fetchFavorite()
                    }
                }
            } else {
                ZZText("Vous n'avez aucun aquarium en favori")
            }
        case .failed(let error):
            ZZText(
                error.localizedDescription,
                frameAlignment: .center
            )
        }
    }
    
    @ViewBuilder
    private var list: some View {
        switch viewModel.dataListState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
        case .loaded(let aquariums):
            if aquariums.isEmpty {
                ZZText("Vous n'avez configuré aucun aquarium")
            } else {
                ForEach(aquariums) { aquarium in
                    AquariumCellView(item: aquarium) {
                        Task {
                            await viewModel.fetchFavorite()
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteAquarium = aquarium
                            showDeletePopup = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        case .failed(let error):
            ZZText(error.localizedDescription)
        }
    }
}

#if DEBUG

import Data

#Preview("Loaded") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withListState: .loaded(AquariumUI.Fake.list),
            withFavoriteState: .loaded(AquariumUI.Fake.preview)
        )
    )
}

#Preview("Loaded - Empty") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withListState: .loaded([]),
            withFavoriteState: .loaded(nil)
        )
    )
}

#Preview("Loading") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withListState: .loading,
            withFavoriteState: .loading
        )
    )
}

#Preview("Loading") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withListState: .loaded(AquariumUI.Fake.list),
            withFavoriteState: .loading
        )
    )
}

#Preview("Loading") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withListState: .loading,
            withFavoriteState: .loaded(AquariumUI.Fake.preview)
        )
    )
}

#Preview("Error") {
    AquariumListView(
        viewModel: FakeAquariumListViewModel(
            withListState: .failed(DataError.network),
            withFavoriteState: .failed(DataError.network)
        )
    )
}

#endif
