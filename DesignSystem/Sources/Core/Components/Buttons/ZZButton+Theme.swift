//
//  ZZButton+Theme.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SwiftUI

extension ZZButton {

    public enum Theme: CaseIterable {

        case primary
        case secondary
        case tertiary
        case ghostLight
        case ghostDark
        case destructive
        case tag

        // MARK: - Foreground

        var foregroundColor: Color {
            switch self {
            case .primary:
                Color.lightHightest
            case .secondary, .tag:
                Color.neutralMedium
            case .tertiary:
                Color.lightHightest
            case .ghostLight:
                Color.lightHightest
            case .ghostDark:
                Color.neutralMedium
            case .destructive:
                Color.dangerLowest
            }
        }

        var foregroundPressedColor: Color {
            switch self {
            case .primary:
                Color.neutralLowest
            case .secondary, .tag:
                Color.neutralMedium
            case .tertiary:
                Color.lightHightest
            case .ghostLight:
                Color.lightHightest
            case .ghostDark:
                Color.neutralMedium
            case .destructive:
                Color.dangerLowest
            }
        }

        var foregroundDisabledColor: Color {
            switch self {
            case .primary:
                Color.neutralLowest
            case .secondary, .tag:
                Color.neutralLow
            case .tertiary:
                Color.neutralLow
            case .ghostLight:
                Color.neutralLow
            case .ghostDark:
                Color.neutralLow
            case .destructive:
                Color.neutralHight
            }
        }

        // MARK: - Background

        var backgroundColor: Color {
            switch self {
            case .primary:
                .primaryMedium
            case .secondary:
                .neutralLowest
            case .tag:
                .white
            case .tertiary:
                .neutralMedium
            case .ghostLight, .ghostDark:
                .clear
            case .destructive:
                .dangerMedium
            }
        }

        var backgroundPressedColor: Color {
            switch self {
            case .primary:
                .primaryMedium
            case .secondary, .tag:
                .neutralLowest
            case .tertiary:
                .neutralMedium
            case .ghostLight:
                .neutralMedium
            case .ghostDark:
                .neutralLowest
            case .destructive:
                .dangerMedium
            }
        }

        var backgroundDisabledColor: Color {
            switch self {
            case .primary:
                .neutralLowest
            case .secondary, .tag:
                .neutralLowest
            case .tertiary:
                .neutralLowest
            case .ghostLight, .ghostDark:
                .clear
            case .destructive:
                .neutralLower
            }
        }

        // MARK: - Border

        var borderColor: Color? {
            switch self {
            case .primary:
                .primaryHight
            case .secondary:
                .neutralLowest
            case .tertiary, .tag:
                .neutralLower
            case .ghostLight, .ghostDark:
                nil
            case .destructive:
                nil
            }
        }

        var borderPressedColor: Color? {
            switch self {
            case .primary:
                .primaryHight
            case .secondary, .tag:
                .primaryMedium
            case .tertiary:
                .neutralMedium
            case .ghostLight, .ghostDark:
                .neutralMedium
            case .destructive:
                .dangerMedium
            }
        }

        var borderDisabledColor: Color? {
            switch self {
            case .primary:
                .neutralLowest
            case .secondary, .tag:
                .neutralLowest
            case .tertiary:
                .neutralLower
            case .ghostLight, .ghostDark:
                nil
            case .destructive:
                nil
            }
        }

        // MARK: - Icon

        var iconForegroundColor: Color {
            switch self {
            case .primary, .secondary, .tag,
                .tertiary, .ghostLight, .ghostDark, .destructive:
                foregroundColor
            }
        }

        var iconForegroundPressedColor: Color {
            switch self {
            case .primary, .secondary, .tag,
                .tertiary, .ghostLight, .ghostDark, .destructive:
                foregroundPressedColor
            }
        }

        var iconForegroundDisabledColor: Color {
            switch self {
            case .primary, .secondary, .tag,
                .tertiary, .ghostLight, .ghostDark, .destructive:
                foregroundDisabledColor
            }
        }
    }
}
