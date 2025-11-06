//
//  SKToast+presentToast.swift
//  GrandTour
//
//  Created by JC Neboit on 27/10/2025.
//

import SKToast
import SwiftUI

extension SKToast {

    public func presentSuccess(label: String) {
        present(
            ZZToast.success(
                image: Image(systemName: "checkmark.circle"),
                label: label
            )
        )
    }

    public func presentError(error: Error) {
        present(
            ZZToast.error(error)
        )
    }

    public func presentError(error: String) {
        present(
            ZZToast.error(error)
        )
    }

    public func presentComingSoon() {
        present(
            ZZToast.comingSoon()
        )
    }
}
