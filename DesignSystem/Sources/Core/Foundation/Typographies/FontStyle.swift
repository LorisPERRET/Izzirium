//
//  FontStyle.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import Foundation
import SwiftUI

public struct FontStyle: Sendable, Hashable {

    // MARK: Properties

    let font: SwiftUI.Font
    public let uiFont: FontConvertible.Font
    let textCase: Text.Case?
    let textStyle: SwiftUI.Font.TextStyle

    let size: CGFloat
    let lineHeight: CGFloat
    let letterSpacing: CGFloat?
    let baselineOffset: CGFloat

    // MARK: Init

    public init(
        fontConvertible: FontConvertible,
        size: CGFloat,
        lineHeight: CGFloat,
        textStyle: SwiftUI.Font.TextStyle = .body,
        letterSpacing: CGFloat? = nil,
        textCase: Text.Case? = nil
    ) {
        self.textStyle = textStyle
        self.font = fontConvertible.swiftUIFont(size: size, relativeTo: textStyle)
        self.uiFont = fontConvertible.font(size: size)
        self.textCase = textCase ?? .none

        self.size = size
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.baselineOffset = Self.baselineOffset(lineHeight: lineHeight, size: size)
    }

    private static func baselineOffset(lineHeight: CGFloat, size: CGFloat) -> CGFloat {
        // Computing the baselineOffset needed to center the text in its line height.
        // The baselineOffset should be the quarter of the difference between size and lineheight.
        (lineHeight - size) / 4 // swiftlint:disable:this no_magic_numbers
    }
}
