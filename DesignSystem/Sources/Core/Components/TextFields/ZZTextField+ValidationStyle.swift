//
//  ZZTextField+ValidationStyle.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import SwiftUI

extension ZZTextField {

    /// Define how ``ZZTextField`` rules are validated
    public enum ValidationStyle {

        /// Always validate field rules
        case alwaysDisplayed

        /// Validate field rules only when submitting
        case submit
    }
}
