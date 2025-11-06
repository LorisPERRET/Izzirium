//
//  View+navigationBarDismissButton.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

struct ZZBackButtonModifier: ViewModifier {

    // MARK: Properties

    @Environment(\.isPresented) private var isPresented
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var pathNavigator: ZZPathNavigator

    let isVisible: Bool

    // MARK: Views

    @ToolbarContentBuilder
    private var backToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ZZButton(
                title: nil,
                iconType: .alone(image: pathNavigator.isEmpty ? Image(systemName: "xmark") : Image(systemName: "chevron.left")),
                theme: .secondary,
                width: .fit
            ) {
                if pathNavigator.isEmpty {
                    dismiss()
                } else {
                    pathNavigator.pop()
                }
            }
        }
        .zzToolbarItemStyle()
    }

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if isPresented && isVisible {
                    backToolbarItem
                }
            }
    }
}

extension View {

    public func navigationBarDismissButton(isVisible: Bool = true) -> some View {
        self.modifier(ZZBackButtonModifier(isVisible: isVisible))
    }
}
