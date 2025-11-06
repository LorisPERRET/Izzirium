//
//  View+magicPadding.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SwiftUI

extension View {

    /// Applies the specified padding to the component
    ///
    /// - Parameter distance: the padding to apply
    public func padding(_ distance: MagicUnit) -> some View {
        self.padding(distance.rawValue)
    }

    /// Applies the specified padding to the specified edges of the component
    ///
    /// - Parameter edges: the edges to which apply the paddings
    /// - Parameter distance: the padding to apply
    public func padding(_ edges: Edge.Set, _ distance: MagicUnit) -> some View {
        self.padding(edges, distance.rawValue)
    }
}
