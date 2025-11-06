//
//  View+hidden.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 10/03/2025.
//

import SwiftUI

struct HiddenModifier: ViewModifier {

    // MARK: Properties

    let isHidden: Bool

    // MARK: ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        if isHidden {
            content
                .hidden()
        } else {
            content
        }
    }
}

extension View {

    func hidden(_ isHidden: Bool = true) -> some View {
        modifier(
            HiddenModifier(isHidden: isHidden)
        )
    }
}
