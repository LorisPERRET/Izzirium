//
//  ZZLoaderView.swift
//  DesignSystem
//
//  Created by JC Neboit on 24/09/2025.
//

import SwiftUI

public struct ZZLoaderView: View {

    // MARK: View

    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .padding(MagicUnit.mu050)
            .background {
                Capsule()
                    .defaultFill()
            }
    }

    // MARK: Init

    public init() {}
}

#Preview(traits: .sizeThatFitsLayout) {
    ZZLoaderView()
}
