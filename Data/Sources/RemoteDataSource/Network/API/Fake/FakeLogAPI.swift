//
//  FakeLogAPI.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation

#if API_MOCK

import Foundation
import PapyrusAlamofire

final class FakeLogAPI: LogAPI {

    // MARK: - Properties

    let sleepTime: UInt64 = 2_000_000_000

    // MARK: - LogAPI
    
    func getLogs(aquarium id: Int) async throws -> [LogDTO] {
        LogDTO.Fake.list
    }
}

#endif
