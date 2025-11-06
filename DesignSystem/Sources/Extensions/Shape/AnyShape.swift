//
//  AnyShape.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import SwiftUI

struct AnyShape: Shape, @unchecked Sendable {

    // MARK: Properties

    private let _path: (CGRect) -> Path

    // MARK: Init

    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    // MARK: Shape

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
