//
//  ButtonIconType.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 25/02/2025.
//

import SwiftUI

public enum ButtonIcon {

    case image(Image, raw: Bool = false, forcedColor: Color? = nil)
    case badge(Int)
}

/// Determine which image and how it will be displayed
public indirect enum ButtonIconType {

    /// Top edge of the view
    case top(image: Image, raw: Bool = false, forcedColor: Color? = nil)

    /// Trailing edge of the view
    case trailing(ButtonIcon)

    /// Bottom edge of the view
    case bottom(image: Image, raw: Bool = false, forcedColor: Color? = nil)

    /// Leading edge of the view
    case leading(image: Image, raw: Bool = false, forcedColor: Color? = nil)

    /// Center of the view (image will be alone)
    case alone(image: Image, raw: Bool = false, forcedColor: Color? = nil)

    /// Multiple
    case multiple(types: [Self])

    /// No Icon
    case noIcon

    // MARK: - Properties

    var hasIcon: Bool {
        switch self {
        case .noIcon:
            false
        case .trailing, .leading, .top, .bottom, .alone, .multiple:
            true
        }
    }

    var isIconButton: Bool {
        switch self {
        case .alone:
            true
        case .trailing, .leading, .noIcon, .top, .bottom, .multiple:
            false
        }
    }

    var isVerticalIcon: Bool {
        switch self {
        case .top, .bottom:
            true
        case .alone, .trailing, .leading, .noIcon:
            false
        case .multiple(let types):
            types.contains { $0.isVerticalIcon }
        }
    }

    var forcedColor: Color? {
        switch self {
        case .top(_, _, let forcedColor),
             .bottom(_, _, let forcedColor),
             .leading(_, _, let forcedColor),
             .alone(_, _, let forcedColor):
            forcedColor
        case .trailing(let item):
            switch item {
            case .image(_, _, let forcedColor):
                forcedColor
            case .badge:
                nil
            }
        case .noIcon:
            nil
        case .multiple:
            // Multiple icon types have no forced color, get forced color for each icon type
            nil
        }
    }

    var isRaw: Bool {
        switch self {
        case .top(_, let raw, _),
            .bottom(_, let raw, _),
            .leading(_, let raw, _),
            .alone(_, let raw, _):
            raw
        case .trailing(let item):
            switch item {
            case .image(_, let raw, _):
                raw
            case .badge:
                false
            }
        case .noIcon:
            false
        case .multiple:
            // Multiple icon types have no raw, get raw for each icon type
            false
        }
    }

    var isTop: Bool {
        switch self {
        case .top:
            true
        case .trailing, .bottom, .leading, .alone, .noIcon, .multiple:
            false
        }
    }

    var isBottom: Bool {
        switch self {
        case .bottom:
            true
        case .trailing, .top, .leading, .alone, .noIcon, .multiple:
            false
        }
    }

    var isleading: Bool {
        switch self {
        case .leading:
            true
        case .trailing, .top, .bottom, .alone, .noIcon, .multiple:
            false
        }
    }

    var isTrailing: Bool {
        switch self {
        case .trailing:
            true
        case .leading, .top, .bottom, .alone, .noIcon, .multiple:
            false
        }
    }
}
