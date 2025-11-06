//
//  View+expand.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 25/02/2025.
//

import SwiftUI

extension View {

    public func expand(alignment: Alignment = .center) -> some View {
        self
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: alignment
            )
    }
}
