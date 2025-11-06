//
//  View+cornerRadius.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SKUI
import SwiftUI

extension View {

    /// Applies the specified padding to the component
    ///
    /// - Parameter distance: the padding to apply
    public func zzRadius(_ radius: RadiusStyle) -> some View {
        self.cornerRadius(radius.rawValue, antialiased: true) // swiftlint:disable:this forbidden_native_radius_modifier
    }

    /// Applies the specified radius to the specified component borders
    ///
    /// - Parameter style: the radius to apply
    /// - Parameter corners: the corners to which apply the radius
    public func zzRadius(_ style: RadiusStyle, corners: UIRectCorner) -> some View {
        self.cornerRadius(radius: style.rawValue, corners: corners) // swiftlint:disable:this forbidden_native_radius_modifier
    }
}
