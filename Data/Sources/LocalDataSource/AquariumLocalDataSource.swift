//
//  AquariumLocalDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
protocol AquariumLocalDataSourceProtocol: Sendable {

    func getAquariums() -> [AquariumData]
    func getAquarium(byId id: Int) throws -> AquariumData
    func saveAquariums(aquariums: [AquariumData], deleteOther: Bool)
}

final class AquariumLocalDataSource: AquariumLocalDataSourceProtocol {

    // MARK: - Properties

    private let logger = Logger(category: AquariumLocalDataSource.self)

    // MARK: - AquariumLocalDataSourceProtocol

    func getAquariums() -> [AquariumData] {
        ZZDatabase.persistent.fetchAll(AquariumData.self)
    }
    
    func getAquarium(byId id: Int) throws -> AquariumData {
        try ZZDatabase.persistent.getAquariumById(id: id)
    }
    
    func saveAquariums(aquariums: [AquariumData], deleteOther: Bool) {
        ZZDatabase.persistent.insertArray(aquariums, deleteOther: deleteOther)
    }
}

extension InjectedValues {

    @Inject var aquariumLocalDataSource: AquariumLocalDataSourceProtocol = AquariumLocalDataSource()
}
