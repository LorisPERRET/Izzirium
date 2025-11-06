//
//  ZZToastView.swift
//  GrandTour
//
//  Created by JC Neboit on 21/10/2025.
//

import SwiftUI

struct ZZToastView: View {

    // MARK: Enum

    enum Style {

        case success
        case error

        var backgroundColor: Color {
            switch self {
            case .success:
                .neutralMedium
            case .error:
                .dangerMedium
            }
        }
    }

    // MARK: Properties

    private let image: Image
    private let label: String
    private let style: Style

    // MARK: View

    var body: some View {
        HStack(spacing: MagicUnit.mu075.rawValue) {
            image.renderingMode(.template)

            ZZText(label, font: .textBase)
        }
        .foregroundStyle(.white)
        .padding(.vertical, MagicUnit.mu100.rawValue)
        .padding(.horizontal, MagicUnit.mu075.rawValue)
        .background {
            RoundedRectangle(cornerRadius: RadiusStyle.small.rawValue)
                .fill(
                    style.backgroundColor,
                    strokeBorder: Color.neutralLower,
                    lineWidth: .small
                )
        }
    }

    // MARK: Init

    init(
        image: Image,
        label: String,
        style: Style = .success
    ) {
        self.image = image
        self.label = label
        self.style = style
    }
}

#if DEBUG

#Preview {
    VStack {
        ZZToastView(
            image: Image(systemName: "checkmark"),
            label: "Ajouté à Week-end Rhône"
        )
    }
}

#endif
