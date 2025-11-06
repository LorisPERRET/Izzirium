//
//  View+cardBackground.swift
//  ZZDesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import SwiftUI

private struct CardBackgroundModifier: ViewModifier {

    // MARK: Properties

    private let minHeight: MagicUnit?
    private let maxHeight: CGFloat?
    private let alignment: Alignment
    private let color: Color
    private let horizontalPadding: MagicUnit
    private let verticalPadding: MagicUnit
    private let radius: RadiusStyle

    // MARK: Init

    init(
        minHeight: MagicUnit?,
        maxHeight: CGFloat?,
        alignment: Alignment,
        color: Color,
        horizontalPadding: MagicUnit,
        verticalPadding: MagicUnit,
        radius: RadiusStyle
    ) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
        self.color = color
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.radius = radius
    }

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content
            .frame(
                minHeight: minHeight?.rawValue,
                maxHeight: maxHeight,
                alignment: alignment
            )
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                RoundedRectangle(
                    cornerRadius: radius.rawValue,
                    style: .continuous
                )
                .fill(color)
            )
    }
}

extension View {

    func cardBackground(
        minHeight: MagicUnit? = MagicUnit.mu300,
        maxHeight: CGFloat? = nil,
        alignment: Alignment? = nil,
        color: Color = Color.neutralLower,
        horizontalPadding: MagicUnit = MagicUnit.mu100,
        verticalPadding: MagicUnit = MagicUnit.mu075,
        radius: RadiusStyle = .medium
    ) -> some View {
        self.modifier(
            CardBackgroundModifier(
                minHeight: minHeight,
                maxHeight: maxHeight,
                alignment: alignment ?? .center,
                color: color,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                radius: radius
            )
        )
    }
}
