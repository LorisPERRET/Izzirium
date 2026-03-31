//
//  AquariumLocalDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection
import SKLocalStorage

@MainActor
protocol AquariumLocalDataSourceProtocol: Sendable {

    func setFavoriteAquarium(id: Int?) async
    func getFavoriteAquariumId() async -> Int?
    func getAquariums() -> [AquariumData]
    func getAquarium(byId id: Int) throws -> AquariumData
    func saveAquariums(aquariums: [AquariumData], deleteOther: Bool)
    func save()
}

@InjectedMember(\.userDefaultsStorage, protocol: (any UserDefaultsStorageProtocol<UserDefaultsStorageKey>).self)
final class AquariumLocalDataSource: AquariumLocalDataSourceProtocol {

    // MARK: - Properties

    private let logger = Logger(category: AquariumLocalDataSource.self)

    // MARK: - AquariumLocalDataSourceProtocol

    func setFavoriteAquarium(id: Int?) async {
        await userDefaultsStorage.set(\.favoriteAquariumId, value: id.map{ NSNumber(value: $0) })
    }
    
    func getFavoriteAquariumId() async -> Int? {
        await userDefaultsStorage.get(\.favoriteAquariumId)?.intValue ?? nil
    }

    func getAquariums() -> [AquariumData] {
        ZZDatabase.persistent.fetchAll(AquariumData.self)
    }
    
    func getAquarium(byId id: Int) throws -> AquariumData {
        try ZZDatabase.persistent.getAquariumById(id: id)
    }
    
    func saveAquariums(aquariums: [AquariumData], deleteOther: Bool) {
        ZZDatabase.persistent.insertArray(aquariums, deleteOther: deleteOther)
    }

    func save() {
        ZZDatabase.persistent.save()
    }
}

extension InjectedValues {

    @Inject var aquariumLocalDataSource: AquariumLocalDataSourceProtocol = AquariumLocalDataSource()
}
