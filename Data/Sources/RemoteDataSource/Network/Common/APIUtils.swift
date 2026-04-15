//
//  APIUtils.swift
//  Data
//
//  Created by Loris Perret on 15/04/2026.
//

import PapyrusAlamofire

enum APIUtils {

    static func request<T>(_ functionName: String, logger: Logger, content: () async throws -> T) async throws -> T {
        do {
            return try await content()
        } catch let error as PapyrusError {
            logger.error("\(functionName) failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("\(functionName) status code: \(statusCode)")

            throw DataError.network
        } catch let error as DecodingError {
            logger.error(error.localizedDescription)
            throw DataError.decoding
        } catch {
            logger.error(error.localizedDescription)
            throw DataError.network
        }
    }

    static func request(_ functionName: String, logger: Logger, content: () async throws -> Void) async throws {
        do {
            try await content()
        } catch let error as PapyrusError {
            logger.error("\(functionName) failed: \(error.message)")

            guard let response = error.response, let statusCode = response.statusCode else {
                throw DataError.network
            }

            if statusCode == 401 {
                throw DataError.invalidCredentials
            }

            logger.error("\(functionName) status code: \(statusCode)")

            throw DataError.network
        } catch let error as DecodingError {
            logger.error(error.localizedDescription)
            throw DataError.decoding
        } catch {
            logger.error(error.localizedDescription)
            throw DataError.network
        }
    }
}
