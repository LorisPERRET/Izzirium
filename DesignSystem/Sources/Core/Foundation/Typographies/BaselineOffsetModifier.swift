//
//  BaselineOffsetModifier.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

import SwiftUI

public struct BaselineOffsetModifier: ViewModifier {

    // MARK: Properties

    let offset: CGFloat

    // MARK: ViewModifier

    public func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .baselineOffset(offset)
        } else {
            content
        }
    }
}
