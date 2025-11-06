//
//  AnyInsettableShape.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import SwiftUI

public struct AnyInsettableShape: InsettableShape, @unchecked Sendable {

    // MARK: Properties

    private let _path: (CGRect) -> Path
    private let _inset: CGFloat

    // MARK: Init

    public init<S: InsettableShape>(
        _ wrapped: S,
        inset: CGFloat = 0
    ) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
        self._inset = inset
    }

    private init(
        path: @escaping (CGRect) -> Path,
        inset: CGFloat = 0
    ) {
        self._path = path
        self._inset = inset
    }

    // MARK: InsettableShape

    public func inset(by amount: CGFloat) -> Self {
        .init(path: _path, inset: amount)
    }

    // MARK: Public methods

    public func path(in rect: CGRect) -> Path {
        _path(
            rect.inset(
                by: .init(
                    top: _inset,
                    left: _inset,
                    bottom: _inset,
                    right: _inset
                )
            )
        )
    }
}
