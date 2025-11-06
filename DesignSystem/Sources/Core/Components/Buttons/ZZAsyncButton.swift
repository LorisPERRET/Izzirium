//
//  ZZAsyncButton.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SKState
import SwiftUI

public struct ZZAsyncButton: View {

    // MARK: Properties

    @Environment(\.isEnabled) private var isEnabled

    @State private var isLoading = false

    private let size: ZZButton.Size
    private let width: ZZButton.Width
    private let theme: ZZButton.Theme
    private let shape: ZZButton.Shape
    private let alignment: HorizontalAlignment

    private let iconType: ButtonIconType // 4 icon Type ? Add init with only icon for alone
    private let title: String?
    private let action: () async -> Void

    // MARK: View

    public var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            makeLabel()
        }
        .buttonStyle(
            ZZButtonStyle(
                size: size,
                theme: theme,
                width: width,
                shape: shape,
                iconType: iconType,
                alignment: alignment,
                isLoading: isLoading
            )
        )
    }

    // MARK: - Init

    public init(
        title: String? = nil,
        iconType: ButtonIconType = .noIcon,
        theme: ZZButton.Theme = .primary,
        size: ZZButton.Size = .medium,
        shape: ZZButton.Shape = .capsule,
        width: ZZButton.Width = .fill,
        alignment: HorizontalAlignment = .center,
        action: @escaping () async -> Void
    ) {
        self.theme = theme
        self.size = size
        self.width = width
        self.iconType = iconType
        self.shape = shape
        self.title = title
        self.action = action
        self.alignment = alignment
    }

    // MARK: - Private methods

    @ViewBuilder
    func makeLabel() -> some View {
        if let title {
            makeTitle(title)
        }
    }

    private func makeTitle(_ title: String) -> some View {
        Text(title) // swiftlint:disable:this forbidden_native_text
            .zzFont(.textMediumS)
            .underline(theme == .ghostLight || theme == .ghostDark)
    }
}
