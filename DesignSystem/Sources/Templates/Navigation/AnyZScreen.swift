//
//  AnyZZScreen.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

public protocol ZZScreenProtocol: Equatable, Hashable, Identifiable {

    // MARK: Associated type

    associatedtype SomeView: View

    // MARK: Properties

    @ViewBuilder
    @MainActor var screen: SomeView { get }
    var id: String { get }
}

public struct AnyZZScreen: ZZScreenProtocol {

    // MARK: Properties

    public let anyScreen: any ZZScreenProtocol

    public var id: String {
        anyScreen.id
    }

    @ViewBuilder
    public var screen: some View {
        AnyView(anyScreen.screen)
    }

    // MARK: Init

    public init(_ anyScreen: any ZZScreenProtocol) {
        self.anyScreen = anyScreen
    }
}

extension ZZScreenProtocol {

    // MARK: Equatable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
