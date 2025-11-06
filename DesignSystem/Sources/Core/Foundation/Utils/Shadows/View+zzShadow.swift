//
//  View +zzShadow.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import SwiftUI

extension View {

    /// Applies the specified shadow to the component
    ///
    /// - Parameter style: the shadow to apply
    public func zzShadow(_ style: ShadowStyle) -> some View {
        let shadowOpacity = 0.1

        // swiftlint:disable:next forbidden_native_shadow_modifier
        return self.shadow(
            color: Color
                .darkHightest
                .opacity(shadowOpacity),
            radius: style.radiusStyle.rawValue,
            x: 0,
            y: style.yOffset
        )
    }
}
