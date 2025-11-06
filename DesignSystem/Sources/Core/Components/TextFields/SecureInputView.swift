//
//  SecureInputView.swift
//  DesignSystem
//
//  Created by Benjamin Lambert on 11/07/2025.
//

import SwiftUI

struct SecureInputView: View {

    // MARK: Properties

    @Binding private var text: String

    @State private var isSecured = true

    private var title: String

    // MARK: View

    var body: some View {
        HStack(spacing: MagicUnit.mu100.rawValue) {
            if isSecured {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }

            Spacer()

            eyeImage(isSecured: isSecured)
                .renderingMode(.template)
                .foregroundStyle(Color.neutralMedium)
                .onTapGesture(count: 1) {
                    isSecured.toggle()
                }
                .accessibilityAddTraits(.isButton)
        }
    }

    // MARK: Init

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    // MARK: Private methods

    private func eyeImage(isSecured: Bool) -> Image {
        if isSecured {
            Image(systemName: "eye")
        } else {
            Image(systemName: "eye.slash")
        }
    }
}
