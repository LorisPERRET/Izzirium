//
//  View +zzNavigationDestinationForAnyZZScreen.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

private struct ZZNavigationDestinationForAnyZZScreenModifier: ViewModifier {

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content
            .zzNavigationDestination(for: AnyZZScreen.self) { item in
                item.screen
            }
    }
}

extension View {

    public func zzNavigationDestinationForAnyZZScreen() -> some View {
        modifier(ZZNavigationDestinationForAnyZZScreenModifier())
    }
}
