//
//  ZZPathNavigator.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

@MainActor
public class ZZPathNavigator: ObservableObject {

    // MARK: - Properties

    private let pathBinding: Binding<[AnyZZScreen]>

    public var path: [AnyZZScreen] {
        get { pathBinding.wrappedValue }
        set { pathBinding.wrappedValue = newValue }
    }

    public var isEmpty: Bool {
        path.isEmpty
    }

    // MARK: - Init

    public init(_ pathBinding: Binding<[AnyZZScreen]>) {
        self.pathBinding = pathBinding
    }

    // MARK: Public methods

    public func append(_ screen: AnyZZScreen) {
        path.append(screen)
    }

    public func pop() {
        guard !path.isEmpty else {
            return
        }
        path.removeLast()
    }

    public func popToRoot() {
        guard !path.isEmpty else {
            return
        }
        path = []
    }
}
