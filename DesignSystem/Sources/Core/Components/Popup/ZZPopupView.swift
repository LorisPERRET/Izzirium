//
//  ZZPopupView.swift
//  DesignSystem
//
//  Created by Loris Perret on 27/10/2025.
//

import SwiftUI

public struct ZZPopupView: View {

    // MARK: - Properties

    let title: String
    let subtitle: String?
    let buttons: [ActionButton]
    let alignment: ZZPopupView.ButtonAlignment

    // MARK: - Body

    public var body: some View {
        VStack(spacing: MagicUnit.mu125.rawValue) {
            texts
            buttonsView
        }
        .padding(.vertical, .mu250)
        .padding(.horizontal, .mu150)
        .background {
            RoundedRectangle(cornerRadius: RadiusStyle.medium.rawValue)
                .fill(Color.white)
        }
        .padding(.mu100)
    }

    // MARK: - Subviews

    private var texts: some View {
        VStack(spacing: MagicUnit.mu050.rawValue) {
            ZZText(
                title,
                font: .textSemiBoldBase,
                foregroundColor: .neutralMedium,
                multilineTextAlignment: .center,
                frameAlignment: .center
            )

            if let subtitle {
                ZZText(
                    subtitle,
                    font: .textBase,
                    foregroundColor: .neutralMedium,
                    multilineTextAlignment: .center,
                    frameAlignment: .center
                )
            }
        }
    }

    @ViewBuilder
    private var buttonsView: some View {
        switch alignment {
        case .horizontal:
            HStack(spacing: MagicUnit.mu050.rawValue) {
                ForEach(buttons) { button in
                    buttonView(button)
                }
            }
        case .vertical:
            VStack(spacing: MagicUnit.mu050.rawValue) {
                ForEach(buttons) { button in
                    buttonView(button)
                }
            }
        }
    }

    @ViewBuilder
    private func buttonView(_ button: ActionButton) -> some View {
        ZZAsyncButton(
            title: button.title,
            theme: button.type.theme
        ) {
            await button.action()
        }
    }
}

#if DEBUG

#Preview {
    ZZPopupView(
        title: "Test",
        subtitle: "Test",
        buttons: [
            ActionButton(title: "Test", type: .primary, action: { print("Test") }),
            ActionButton(title: "Test", type: .secondary, action: { print("Test") }),
            ActionButton(title: "Test", type: .destructive, action: { print("Test") })
        ],
        alignment: .horizontal
    )
}

#Preview {
    ZZPopupView(
        title: "Test",
        subtitle: "Test",
        buttons: [
            ActionButton(title: "Test", type: .primary, action: { print("Test") }),
            ActionButton(title: "Test", type: .secondary, action: { print("Test") }),
            ActionButton(title: "Test", type: .destructive, action: { print("Test") })
        ],
        alignment: .vertical
    )
}

#endif
