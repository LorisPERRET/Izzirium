//
//  EmptyZZScreen.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

public struct EmptyZZScreen: ZZScreenProtocol {

    // MARK: Properties

    public var id: String {
        UUID().uuidString
    }

    @ViewBuilder
    public var screen: some View {
        AnyView(
            EmptyView()
        )
    }

    // MARK: Init

    public init() {}
}
