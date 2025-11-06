//
//  View+transition.swift
//  DesignSystem
//
//  Created by JC Neboit on 16/10/2025.
//

import SwiftUI

extension View {

    @ViewBuilder
    public func zzMatchedTransitionSource(id: some Hashable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }

    @ViewBuilder
    public func zzNavigationTransition(id: some Hashable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.navigationTransition(
                .zoom(
                    sourceID: id,
                    in: namespace
                )
            )
        } else {
            self
        }
    }
}
