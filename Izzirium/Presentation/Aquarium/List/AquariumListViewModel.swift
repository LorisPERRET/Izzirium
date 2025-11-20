//
//  AquariumListViewModel.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import Foundation
//import Kastor
import SKDependencyInjection
import SKState

@MainActor
protocol AquariumListViewModelProtocol: ObservableObject {
    
    var dataState: SKLoadingState<[AquariumUI]> { get }
    
    func fetchAquariums() async
}

final class AquariumListViewModel: AquariumListViewModelProtocol {

    // MARK: - Properties
    
    @Published private(set) var dataState: SKLoadingState<[AquariumUI]> = .loading

//    private let logger = Logger(category: AquariumListViewModel.self)

    // MARK: - AquariumListViewModelProtocol

    func fetchAquariums() async {
//        logger.info("fetchAquariums")
        
        dataState = .loaded(AquariumUI.Fake.list)
    }
}
