//
//  ZZToast+types.swift
//  GrandTour
//
//  Created by JC Neboit on 16/10/2025.
//

import SwiftUI

extension ZZToast {

    public static func success(image: Image, label: String) -> ZZToast {
        ZZToast(
            image: image,
            label: label,
            style: .success,
            duration: .medium
        )
    }

    public static func error(_ error: Error) -> ZZToast {
        Self.error(error.localizedDescription)
    }

    public static func error(_ error: String) -> ZZToast {
        ZZToast(
            image: Image(systemName: "exclamationmark.triangle.fill"),
            label: error,
            style: .error,
            duration: .medium
        )
    }

    public static func comingSoon() -> ZZToast {
        ZZToast(
            image: Image(systemName: "hourglass"),
            label: "Bientôt disponible",
            style: .success,
            duration: .medium
        )
    }
}
