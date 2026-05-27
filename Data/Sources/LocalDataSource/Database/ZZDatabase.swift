//
//  ZZDatabase.swift
//  Data
//
//  Created by Loris Perret on 20/08/2025.
//

import Foundation
import SwiftData

@MainActor
public struct ZZDatabase {

    // MARK: - Error

    public enum Error: Swift.Error, Equatable, LocalizedError {

        case objectNotFound(id: Int)

        public var errorDescription: String? {
            switch self {
            case .objectNotFound(let id):
                return "Object not found for id: \(id)"
            }
        }
    }

    // MARK: - Static Properties

    public static var persistent: ZZDatabase = {
        do {
            let fileManager = FileManager.default
            let folder = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
                .appendingPathComponent("database", isDirectory: true)

            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
            let url = folder.appendingPathComponent("zz.sqlite")

            ZZDatabase.logger.debug("Izzirium database path: \(url)")

            let config = ModelConfiguration(schema: schema, url: url)

            do {
                let container = try ModelContainer(for: schema, configurations: [config])
                return ZZDatabase(container: container)
            } catch {
                ZZDatabase.logger.error("SwiftData init failed, deleting db and retrying: \(error)")

                try? fileManager.removeItem(at: url)
                try? fileManager.removeItem(at: url.appendingPathExtension("shm"))
                try? fileManager.removeItem(at: url.appendingPathExtension("wal"))

                let container = try ModelContainer(for: schema, configurations: [config])
                return ZZDatabase(container: container)
            }
        } catch {
            ZZDatabase.logger.error("Unresolved error: \(error)")
            fatalError("Unresolved error: \(error)")
        }
    }()

    public static var schema: Schema {
        Schema([
            AquariumData.self,
            AlertData.self,
            LogData.self
        ])
    }

    private static let logger = Logger(category: ZZDatabase.self)

    // MARK: - Properties

    let container: ModelContainer
    public let context: ModelContext

    // MARK: - Init

    init(container: ModelContainer) {
        self.container = container
        self.context = ModelContext(container)
    }

    // MARK: - Insert / Update

    public func insert<T: PersistentModel>(_ object: T, deleteOther: Bool = false) {
        do {
            if deleteOther {
                try context.delete(model: T.self)
            }
            try customInsert(object, deleteOther: deleteOther)
            try context.save()
        } catch {
            ZZDatabase.logger.error("❌ Failed to insert: \(error)")
        }
    }

    public func insertArray<T: PersistentModel>(_ objects: [T], deleteOther: Bool = false) {
        do {
            if deleteOther {
                try context.delete(model: T.self)
            }
            for object in objects {
                try customInsert(object, deleteOther: deleteOther)
            }
            try context.save()
        } catch {
            ZZDatabase.logger.error("❌ Failed to insert array: \(error)")
        }
    }

    public func save() {
        do {
            try context.save()
        } catch {
            ZZDatabase.logger.error("❌ Failed to save context: \(error)")
        }
    }

    private func customInsert<T: PersistentModel>(_ object: T, deleteOther: Bool) throws {
        do {
            if let aquarium = object as? AquariumData {
                try updateAquariumData(aquarium)
            }
        } catch {}

        context.insert(object)
    }

    private func updateAquariumData(_ aquarium: AquariumData) throws {
        let existing = try getAquariumById(id: aquarium.modelId)
        if !existing.logs.isEmpty {
            let logs = aquarium.logs
            existing.logs.removeAll()
            aquarium.logs.append(contentsOf: logs)
        }
        try context.save()
    }

    // MARK: - Delete

    public func delete<T: PersistentModel>(_ object: T) {
        context.delete(object)
        do {
            try context.save()
        } catch {
            ZZDatabase.logger.error("❌ Failed to delete: \(error)")
        }
    }

    // MARK: - Fetch

    public func fetchAll<T: PersistentModel>(_ type: T.Type) -> [T] {
        let descriptor = FetchDescriptor<T>()
        do {
            return try context.fetch(descriptor)
        } catch {
            ZZDatabase.logger.error("❌ Failed to fetch \(T.self): \(error)")
            return []
        }
    }

    public func getAquariumById(id: Int) throws -> AquariumData {
        try getObjectById(id: id)
    }

    private func getObjectById<T>(id: Int) throws -> T where T: PersistentModel & ModelIdentifiable {
        do {
            let object = try context.fetch(
                FetchDescriptor<T>(
                    predicate: #Predicate { $0.modelId == id }
                )
            ).first

            guard let object else {
                throw Error.objectNotFound(id: id)
            }

            return object
        } catch {
            ZZDatabase.logger.error("❌ Failed to fetch \(T.self) with id \(id): \(error)")
            throw error
        }
    }

    // MARK: - Others

    public func count<T: PersistentModel>(_ type: T.Type) -> Int {
        let descriptor = FetchDescriptor<T>()
        do {
            return try context.fetchCount(descriptor)
        } catch {
            ZZDatabase.logger.error("❌ Failed to count \(T.self): \(error)")
            return -1
        }
    }
}
