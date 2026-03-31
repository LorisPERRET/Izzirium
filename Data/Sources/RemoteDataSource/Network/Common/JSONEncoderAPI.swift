//
//  JSONEncoderAPI.swift
//  Data
//
//  Created by Thibaut Schmitt on 13/03/2025.
//

import Foundation

final class JSONEncoderAPI: JSONEncoder, @unchecked Sendable {

    // MARK: - Init

    override init() {
        super.init()

        dateEncodingStrategy = .iso8601
    }
}
