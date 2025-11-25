//
//  View+zzNavigationTitle.swift
//  DesignSystem
//
//  Created by JC Neboit on 15/10/2025.
//

import SwiftUI

private struct ZZNavigationTitleModifier: ViewModifier {

    // MARK: Properties

    let title: String

    // MARK: Init

    init(title: String) {
        self.title = title

        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        let largeTitleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: FontStyle.h4.uiFont
        ]
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: FontStyle.textMediumS.uiFont
        ]

        appearance.largeTitleTextAttributes = largeTitleTextAttributes
        appearance.titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content.navigationTitle(title)
    }
}

extension View {

    public func zzNavigationTitle(title: String) -> some View {
        modifier(ZZNavigationTitleModifier(title: title))
    }
}
