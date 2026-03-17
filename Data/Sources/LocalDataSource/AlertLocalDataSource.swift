//
//  AlertLocalDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
protocol AlertLocalDataSourceProtocol: Sendable {

    func getAlert(aquarium id: Int) throws -> AlertData?
}

final class AlertLocalDataSource: AlertLocalDataSourceProtocol {

    // MARK: - Properties

    private let logger = Logger(category: AlertLocalDataSource.self)

    // MARK: - AlertLocalDataSourceProtocol

    func getAlert(aquarium id: Int) throws -> AlertData? {
        try ZZDatabase.persistent.getAquariumById(id: id).alert
    }
}

extension InjectedValues {

    @Inject var alertLocalDataSource: AlertLocalDataSourceProtocol = AlertLocalDataSource()
}
