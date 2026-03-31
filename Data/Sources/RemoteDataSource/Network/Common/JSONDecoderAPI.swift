//
//  JSONDecoder+API.swift
//  Data
//
//  Created by Thibaut Schmitt on 08/03/2024.
//

import Foundation

final class JSONDecoderAPI: JSONDecoder, @unchecked Sendable {

    // MARK: - Init

    override init() {
        super.init()

        dateDecodingStrategy = .iso8601
    }
}
