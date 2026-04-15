//
//  FakeAlertAPI.swift
//  Data
//
//  Created by Loris Perret on 24/11/2025.
//

import Foundation

#if API_MOCK

import Foundation
import PapyrusAlamofire

final class FakeAlertAPI: AlertAPI {

    // MARK: - Properties

    let sleepTime: UInt64 = 2_000_000_000

    // MARK: - LogAPI

    func getAlert(aquarium id: Int) async throws -> AlertDTO? {
        AlertDTO.Fake.preview
    }

    func updateAlert(alert: PapyrusCore.Body<AlertRequestDTO>) async throws -> AlertDTO {
        AlertDTO.Fake.preview
    }
}

#endif
