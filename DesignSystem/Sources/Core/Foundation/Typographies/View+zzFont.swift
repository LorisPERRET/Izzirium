//
//  View +zzFont.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SKUI
import SwiftUI

extension View {

    /// Applies the specified font style to the component
    ///
    /// - Parameter zzFont: the font style to apply
    /// - Parameter withBaselineModifier: indicates whether a baseline offset must be applied
    @MainActor
    public func applyZZFontAdditionnalStyle(
        _ zzFont: FontStyle,
        withBaselineModifier: Bool = true
    ) -> some View {
        self
        // swiftlint:disable:next no_magic_numbers
            .lineSpacing(4)
            .textCase(zzFont.textCase)
    }

    /// Applies the specified font style to the component
    ///
    /// - Parameter zzFont: the font style to apply
    /// - Parameter withBaselineModifier: indicates whether a baseline offset must be applied
    /// - Parameter andFullTextStyle: indicates whether all style must be applied or not (lineSpacing, textCase)
    public func zzFont(
        _ zzFont: FontStyle,
        withBaselineModifier: Bool = true,
        andFullTextStyle: Bool = true
    ) -> some View {
        self
            .font(zzFont.font)
            .kerning(zzFont.letterSpacing ?? 0)
            .baselineOffset(withBaselineModifier ? zzFont.baselineOffset : 0)
            .applyIf(andFullTextStyle) { view in
                view
                    .applyZZFontAdditionnalStyle(
                        zzFont,
                        withBaselineModifier: withBaselineModifier
                    )
            }
    }
}

extension Text {

    /// Applies the specified font style to the component
    ///
    /// - Parameter zzFont: the font style to apply
    /// - Parameter withBaselineModifier: indicates whether a baseline offset must be applied
    /// - Parameter andFullTextStyle: indicates whether all style must be applied or not (lineSpacing, textCase)
    @MainActor
    public func zzFont(
        _ zzFont: FontStyle,
        withBaselineModifier: Bool = true,
        andFullTextStyle: Bool = true
    ) -> some View {
        self
            .applyFont(zzFont)
            .baselineOffset(withBaselineModifier ? zzFont.baselineOffset : 0)
            .applyIf(andFullTextStyle) { view in
                view
                    .applyZZFontAdditionnalStyle(
                        zzFont,
                        withBaselineModifier: withBaselineModifier
                    )
            }
    }

    /// Applies the specified font style to the component
    ///
    /// - Parameter zzFont: the font style to apply
    public func applyFont(
        _ zzFont: FontStyle
    ) -> Text {
        self
            .font(zzFont.font)
            .kerning(zzFont.letterSpacing ?? 0)
    }
}
