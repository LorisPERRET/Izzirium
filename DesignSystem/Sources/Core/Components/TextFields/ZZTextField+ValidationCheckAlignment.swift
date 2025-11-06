//
//  ZZTextField+ValidationCheckAlignment.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import SwiftUI

extension ZZTextField {

    /// Define how ``ZZTextField`` rules are displayed
    public enum ValidationCheckAlignment {

        /// Display checkmark on the left of ZZTextField
        case textfield

        /// Display checkmark on the right of each rules
        case rules
    }
}
