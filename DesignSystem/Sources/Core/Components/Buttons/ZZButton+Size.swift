//
//  ZZButton+Size.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SwiftUI

extension ZZButton {

    public enum Size: CaseIterable {

        case small
        case medium
        case large
        case extraLarge

        var fontStyle: FontStyle {
            switch self {
            case .small, .medium:
                FontStyle.textS
            case .large, .extraLarge:
                FontStyle.textBase
            }
        }

        var iconSize: MagicUnit {
            switch self {
            case .small:
                .mu100
            case .medium, .large, .extraLarge:
                .mu125
            }
        }

        var height: MagicUnit {
            switch self {
            case .small:
                .mu200
            case .medium:
                .mu250
            case .large:
                .mu300
            case .extraLarge:
                .mu300
            }
        }
    }
}
