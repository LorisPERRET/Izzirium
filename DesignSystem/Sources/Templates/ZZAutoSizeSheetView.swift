//
//  ZZAutoSizeSheetView.swift
//  DesignSystem
//
//  Created by JC Neboit on 17/10/2025.
//

import SwiftUI

public struct ZZAutoSizeSheetView<Content: View>: View {

    // MARK: Properties

    @State private var sheetHeight: CGFloat = 0
    private let content: Content

    // MARK: View

    public var body: some View {
        content
            .readSize { newSize in
                sheetHeight = newSize.height
            }
            .presentationDetents([.height(sheetHeight)])
    }

    // MARK: Init

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
}
