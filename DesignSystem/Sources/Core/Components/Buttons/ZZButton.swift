//
//  ZZButton.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SwiftUI

public struct ZZButton: View {

    // MARK: Properties

    @Environment(\.isEnabled) private var isEnabled

    private let size: Size
    private let width: Width
    private let theme: Theme
    private let shape: Shape
    private let alignment: HorizontalAlignment

    private let iconType: ButtonIconType // 4 icon Type ? Add init with only icon for alone
    private let title: String?
    private let action: () -> Void

    // MARK: View

    public var body: some View {
        Button(action: action) {
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
                isLoading: false // add alone icon param if no title and only 1 icon set
            )
        )
    }

    // MARK: - Init

    public init(
        title: String? = nil,
        iconType: ButtonIconType = .noIcon,
        theme: Self.Theme = .primary,
        size: Self.Size = .medium,
        shape: Self.Shape = .capsule,
        width: Self.Width = .fill,
        alignment: HorizontalAlignment = .center,
        action: @escaping () -> Void
    ) {
        self.theme = theme
        self.size = size
        self.width = width
        self.iconType = iconType
        self.shape = shape
        self.title = title
        self.alignment = alignment
        self.action = action
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

// MARK: - Previews

#if DEBUG

final class ZZButton_Previews: PreviewProvider {

    // swiftlint:disable closure_body_length
    // swiftlint:disable function_body_length

    static var previews: some View {
        getButtons(
            title: "Flash",
            iconType: .leading(image: Image(systemName: "flashlight.off.circle")),
            enabled: true
        )
        .previewDisplayName("Icon + Text | Enabled")

        getButtons(
            title: "Filters",
            iconType: .multiple(
                types: [
                    .leading(image: Image(systemName: "camera.filters")),
                    .trailing(.badge(1))
                ]
            ),
            enabled: true
        )
        .previewDisplayName("Icon + Text + Badge | Enabled")

        getButtonsMultipleIconsPosition()
        .previewDisplayName("Multiple Icon + Text | Enabled")

        getButtons(
            title: "Flash",
            iconType: .leading(image: Image(systemName: "flashlight.off.circle")),
            enabled: false
        )
        .previewDisplayName("Icon + Text | Disabled")

        getButtons(
            title: "Flash",
            enabled: true
        )
        .previewDisplayName("Text | Enabled")

        getButtons(
            title: "Flash",
            enabled: false
        )
        .previewDisplayName("Text | Disabled")

        getButtons(
            title: nil,
            iconType: .alone(image: Image(systemName: "flashlight.off.circle")),
            enabled: true
        )
        .previewDisplayName("Icon | Enabled")

        getButtons(
            title: nil,
            iconType: .alone(image: Image(systemName: "flashlight.off.circle")),
            enabled: false
        )
        .previewDisplayName("Icon | Disabled")

        getButtons(
            title: "Flash",
            iconType: .leading(image: Image(systemName: "flashlight.off.circle"), forcedColor: Color.primaryMedium),
            iconColor: Color.primaryMedium,
            enabled: true
        )
        .previewDisplayName("Icon color forced | Enabled")

        getButtons(
            title: "Flash",
            iconType: .leading(image: Image(systemName: "flashlight.off.circle"), forcedColor: Color.primaryMedium),
            iconColor: Color.primaryMedium,
            enabled: false
        )
        .previewDisplayName("Icon color forced | Disabled")
    }

    static func getButtons(
        title: String?,
        iconType: ButtonIconType = .noIcon,
        iconColor: Color? = nil,
        enabled: Bool = true
    ) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(ZZButton.Theme.allCases, id: \.self) { theme in
                    VStack {
                        ForEach(ZZButton.Size.allCases, id: \.self) { size in
                            ZZButton(
                                title: title,
                                iconType: iconType,
                                theme: theme,
                                size: size,
                                width: .fit
                            ) {}
                                .disabled(enabled == false)
                        }
                        ForEach(ZZButton.Size.allCases, id: \.self) { size in
                            ZZButton(
                                title: title,
                                iconType: iconType,
                                theme: theme,
                                size: size,
                                shape: .roundedRectangle(.medium),
                                width: .fit
                            ) {}
                                .disabled(enabled == false)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .scrollIndicators(.hidden)
    }

    static func getButtonsMultipleIconsPosition() -> some View {
        ScrollView {
            VStack {
                HStack {
                    ZZButton(
                        title: "Flash",
                        iconType: .top(image: Image(systemName: "flashlight.off.circle")),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}

                    ZZButton(
                        title: "Flash",
                        iconType: .trailing(
                            .image(Image(systemName: "flashlight.off.circle"))
                        ),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}
                }

                HStack {
                    ZZButton(
                        title: "Flash",
                        iconType: .bottom(image: Image(systemName: "flashlight.off.circle")),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}

                    ZZButton(
                        title: "Flash",
                        iconType: .leading(image: Image(systemName: "flashlight.off.circle")),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}
                }

                HStack {
                    ZZButton(
                        title: "Flash",
                        iconType: .multiple(types: [
                            .trailing(
                                .image(Image(systemName: "flashlight.off.circle"))
                            ),
                            .leading(image: Image(systemName: "flashlight.off.circle"))
                        ]),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}

                    ZZButton(
                        title: "Flash",
                        iconType: .multiple(types: [
                            .top(image: Image(systemName: "flashlight.off.circle")),
                            .bottom(image: Image(systemName: "flashlight.off.circle"))
                        ]),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}
                }

                HStack {
                    ZZButton(
                        title: "Flash",
                        iconType: .multiple(types: [
                            .top(image: Image(systemName: "flashlight.off.circle")),
                            .trailing(
                                .image(Image(systemName: "flashlight.off.circle"))
                            ),
                            .leading(image: Image(systemName: "flashlight.off.circle")),
                            .bottom(image: Image(systemName: "flashlight.off.circle"))
                        ]),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}

                    ZZButton(
                        title: "Flash",
                        iconType: .multiple(types: [
                            .top(image: Image(systemName: "flashlight.off.circle"), forcedColor: Color.blue),
                            .trailing(
                                .image(
                                    Image(systemName: "flashlight.off.circle"),
                                    forcedColor: Color.cyan
                                )
                            ),
                            .leading(image: Image(systemName: "flashlight.off.circle"), forcedColor: Color.green),
                            .bottom(image: Image(systemName: "flashlight.off.circle"), forcedColor: Color.orange)
                        ]),
                        theme: .primary,
                        size: .medium,
                        width: .fit
                    ) {}
                }

                ZZButton(
                    title: "Flash",
                    iconType: .multiple(types: [
                        .top(image: Image(systemName: "flashlight.off.circle")),
                        .trailing(.image(Image(systemName: "flashlight.off.circle")))
                    ]),
                    theme: .primary,
                    size: .medium,
                    width: .fit
                ) {}
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
    }
}

#endif
