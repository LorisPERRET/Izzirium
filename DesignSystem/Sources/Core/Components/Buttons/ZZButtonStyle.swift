//
//  ZZButtonStyle.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SwiftUI

struct ZZButtonStyle: ButtonStyle {

    // MARK: - Properties

    @Environment(\.isEnabled) private var isEnabled

    private let size: ZZButton.Size
    private let theme: ZZButton.Theme
    private let width: ZZButton.Width
    private let shape: ZZButton.Shape
    private let alignment: HorizontalAlignment

    private let iconType: ButtonIconType

    private let isLoading: Bool
    private let stretchesHorizontally: Bool

    private let animationDuration = 0.1
    private let pressedScale = 0.95

    // MARK: - Init

    init(
        size: ZZButton.Size,
        theme: ZZButton.Theme,
        width: ZZButton.Width,
        shape: ZZButton.Shape,
        iconType: ButtonIconType,
        alignment: HorizontalAlignment,
        isLoading: Bool = false
    ) {
        self.size = size
        self.theme = theme
        self.width = width
        self.shape = shape
        self.iconType = iconType
        self.isLoading = isLoading
        self.stretchesHorizontally = width == .fill
        self.alignment = alignment
    }

    // MARK: - ButtonStyle

    func makeBody(configuration: Configuration) -> some View {
        ZStack { // swiftlint:disable:this closure_body_length
            makeLabel(configuration)
                .padding(.horizontal, iconType.isIconButton ? .mu075 : .mu100)
                .padding(.vertical, iconType.isIconButton ? .mu075 : .mu050)
                .foregroundStyle(
                    isLoading ? Color.clear : labelForegroundColor(configuration)
                )
                .frame(
                    minHeight: size.height.rawValue
                )
                .frame(
                    height: iconType.isVerticalIcon ? nil : size.height.rawValue
                )
                .frame(
                    width: iconType.isIconButton ? size.height.rawValue : nil
                )
                .frame(
                    minWidth: iconType.isIconButton ? nil : size.height.rawValue
                )
                .frame(
                    maxWidth: stretchesHorizontally ? .infinity : .none,
                    alignment: Alignment(horizontal: alignment, vertical: .center)
                )
                .background(
                    backgroundShape(
                        isPressed: configuration.isPressed
                    )
                )
                .scaleEffect(isEnabled && !isLoading && configuration.isPressed ? pressedScale : 1)
                .animation(
                    .easeOut(duration: animationDuration),
                    value: configuration.isPressed
                )

            if isLoading {
                loadingLayer()
            }
        }
    }

    @ViewBuilder
    private func makeLabel(_ configuration: Configuration) -> some View {
        switch iconType {
        case .top, .trailing, .bottom, .leading, .multiple:
            let iconTypes = {
                if case let .multiple(types) = iconType {
                    return types
                } else {
                    return [iconType]
                }
            }()

            makeLabel(forIconTypes: iconTypes, configuration)

        case let .alone(icon, raw, forcedColor):
            makeIcon(icon, configuration, raw, forcedColor)

        case .noIcon:
            configuration.label
        }
    }

    @ViewBuilder
    private func makeLabel(forIconTypes iconTypes: [ButtonIconType], _ configuration: Configuration) -> some View {
        let spacing = MagicUnit.mu050.rawValue

        VStack(spacing: spacing) {
            let topIconType = iconTypes.first { $0.isTop }
            if case let .top(icon, raw, forcedColor) = topIconType {
                makeIcon(icon, configuration, raw, forcedColor)
            }

            HStack(spacing: spacing) {
                let leadingIconType = iconTypes.first { $0.isleading }
                if case let .leading(icon, raw, forcedColor) = leadingIconType {
                    makeIcon(icon, configuration, raw, forcedColor)
                }

                configuration.label

                let trailingIconType = iconTypes.first { $0.isTrailing }
                if case let .trailing(item) = trailingIconType {
                    switch item {
                    case let .image(icon, raw, forcedColor):
                        makeIcon(icon, configuration, raw, forcedColor)
                    case let .badge(badge):
                        makeBadge(badge)
                    }
                }
            }

            let bottomIconType = iconTypes.first { $0.isBottom }
            if case let .bottom(icon, raw, forcedColor) = bottomIconType {
                makeIcon(icon, configuration, raw, forcedColor)
            }
        }
    }

    private func makeIcon(_ icon: Image, _ configuration: Configuration, _ isRaw: Bool, _ forcedColor: Color? = nil) -> some View {
        icon
            .resizable()
            .applyIf(!isRaw) { icon in
                icon
                    .renderingMode(.template)
                    .foregroundStyle(
                        iconForegroundColor(
                            configuration,
                            forcedColor
                        )
                    )
            }
            .frame(
                width: size.iconSize.rawValue,
                height: size.iconSize.rawValue
            )
    }

    private func makeBadge(_ badge: Int) -> some View {
        ZStack {
            Circle()
                .fill(theme.foregroundColor)
            Text("\(badge)") // swiftlint:disable:this forbidden_native_text
                .zzFont(.labelXXSsemiBold)
                .foregroundColor(theme.backgroundColor)
        }
        .frame(
            width: size.iconSize.rawValue,
            height: size.iconSize.rawValue
        )
    }

    // MARK: - Colors

    private func labelForegroundColor(_ configuration: Configuration) -> Color {
        switch (isEnabled, configuration.isPressed) {
        case (true, true):
            theme.foregroundPressedColor
        case (true, false):
            theme.foregroundColor
        case (false, _):
            theme.foregroundDisabledColor
        }
    }

    private func iconForegroundColor(_ configuration: Configuration, _ forcedColor: Color? = nil) -> Color {
        if let forcedColor {
            return forcedColor
        }

        switch (isEnabled, configuration.isPressed) {
        case (true, true):
            return theme.iconForegroundPressedColor
        case (true, false):
            return theme.iconForegroundColor
        case (false, _):
            return theme.iconForegroundDisabledColor
        }
    }

    // MARK: - Shapes

    @ViewBuilder
    private func backgroundShape(isPressed: Bool) -> some View {
        ZStack {
            // Background layer
            backgroundLayer()

            // Layer for pressed state
            if isPressed && !isLoading && isEnabled {
                pressedLayer()
            }

            if isEnabled == false {
                disabledLayer()
            }
        }
    }

    private func styleShape() -> some InsettableShape {
        switch shape {
        case .capsule:
            AnyInsettableShape(
                Capsule()
            )
        case .roundedRectangle(let radiusStyle):
            AnyInsettableShape(
                RoundedRectangle(
                    cornerRadius: radiusStyle.rawValue,
                    style: .continuous
                )
            )
        }
    }

    // MARK: - Layers

    @ViewBuilder
    private func backgroundLayer() -> some View {
        if let borderColor = theme.borderColor {
            styleShape()
                .fill(
                    theme.backgroundColor,
                    strokeBorder: borderColor,
                    lineWidth: .small
                )
                .transition(.identity)
        } else {
            styleShape()
                .fill(theme.backgroundColor)
                .transition(.identity)
        }
    }

    @ViewBuilder
    private func pressedLayer() -> some View {
        if let borderPressedColor = theme.borderPressedColor {
            styleShape()
                .fill(
                    theme.backgroundPressedColor,
                    strokeBorder: borderPressedColor,
                    lineWidth: .small
                )
                .transition(.identity)
        } else {
            styleShape()
                .fill(theme.backgroundPressedColor)
        }
    }

    @ViewBuilder
    private func disabledLayer() -> some View {
        if let borderDisabledColor = theme.borderDisabledColor {
            styleShape()
                .fill(
                    theme.backgroundDisabledColor,
                    strokeBorder: borderDisabledColor,
                    lineWidth: .small
                )
                .transition(.identity)
        } else {
            styleShape()
                .fill(theme.backgroundDisabledColor)
        }
    }

    @ViewBuilder
    private func loadingLayer() -> some View {
        ProgressView()
            .foregroundStyle(Color.primaryMedium)
    }
}
