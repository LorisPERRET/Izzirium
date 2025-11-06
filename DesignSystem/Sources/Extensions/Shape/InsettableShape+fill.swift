//
//  InsettableShape+fill.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import SwiftUI

extension InsettableShape {

    func defaultFill() -> some View {
        self.fill(
            Color.white,
            strokeBorder: Color.neutralLower,
            lineWidth: .small
        )
    }

    public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill,
        strokeBorder strokeStyle: Stroke,
        lineWidth: ZZStrokeStyle
    ) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth.rawValue)
            .background(self.fill(fillStyle))
    }
}
