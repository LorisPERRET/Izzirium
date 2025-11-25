//
//  LogLocalDataSource.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation
import SKDependencyInjection

@MainActor
protocol LogLocalDataSourceProtocol: Sendable {

    func getLogs(aquarium id: Int) throws -> [LogData]
}

final class LogLocalDataSource: LogLocalDataSourceProtocol {

    // MARK: - Properties

    private let logger = Logger(category: LogLocalDataSource.self)

    // MARK: - LogLocalDataSourceProtocol

    func getLogs(aquarium id: Int) throws -> [LogData] {
        try ZZDatabase.persistent.getAquariumById(id: id).logs
    }
}

extension InjectedValues {

    @Inject var logLocalDataSource: LogLocalDataSourceProtocol = LogLocalDataSource()
}
