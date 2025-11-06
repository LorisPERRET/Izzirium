//
//  ZZTextFieldValidationMessage.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import Foundation
import SwiftUI

struct ZZTextFieldValidationMessage: Hashable {

    enum ValidationState {

        case invalid
        case neutral
        case valid
    }

    // MARK: Properties

    let state: ValidationState
    let message: String
    let hasCheckMark: Bool
}
