//
//  View+errorToast.swift
//  DesignSystem
//
//  Created by Loris Perret on 20/10/2025.
//

import SKState
import SKToast
import SwiftUI

extension View {

    public func errorToast<T>(publisher: SKDataRequestStatePublisher<T>) -> some View {
        self
            .onReceive(publisher) { requestState in
                guard case let .error(error) = requestState else { return }
                SKToast.shared.presentError(error: error)
            }
    }
}
