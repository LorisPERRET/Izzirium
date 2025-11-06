//
//  View+placeholder.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import SwiftUI

extension View {

    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        foregroundColor: Color = .neutralLow
    ) -> some View {
        placeholder(
            when: shouldShow,
            alignment: alignment
        ) {
            ZZText(
                text,
                font: .textMediumL,
                foregroundColor: foregroundColor
            )
        }
    }

    private func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder()
                .opacity(shouldShow ? 1 : 0)

            self
        }
    }
}
