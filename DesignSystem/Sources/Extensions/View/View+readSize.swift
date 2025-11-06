//
//  View+readSize.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/06/2024.
//

import SwiftUI

private struct SizePreferenceKey: PreferenceKey {

    static var defaultValue: CGSize { .zero }

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct ReadSizeModifier: ViewModifier {

    // MARK: Properties

    @State private var lastSize: CGSize = .zero

    private let onSizeChanged: (CGSize) -> Void
    private let sizeChangeThreshold: CGFloat = 0.000001

    // MARK: Init

    init(onSizeChanged: @escaping (CGSize) -> Void) {
        self.onSizeChanged = onSizeChanged
    }

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: SizePreferenceKey.self,
                            value: geometry.size
                        )
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                Task { @MainActor in
                    let widthChange = abs(newSize.width - lastSize.width)
                    let heightChange = abs(newSize.height - lastSize.height)

                    if widthChange > sizeChangeThreshold || heightChange > sizeChangeThreshold {
                        lastSize = newSize
                        onSizeChanged(newSize)
                    }
                }
            }
    }
}

extension View {

    public func readSize(onSizeChanged: @escaping @MainActor (CGSize) -> Void) -> some View {
        self.modifier(ReadSizeModifier(onSizeChanged: onSizeChanged))
    }
}
