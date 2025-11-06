//
//  ZZToast.swift
//  GrandTour
//
//  Created by JC Neboit on 21/10/2025.
//

import SKToast
import SwiftUI

public struct ZZToast: ToastableItemProtocol {

    // MARK: Properties

    public let id = UUID()
    public let isUserInteractionEnabled = true
    public let timing: ToastDuration

    private let image: Image
    private let label: String
    private let style: ZZToastView.Style

    // MARK: Init

    init(
        image: Image,
        label: String,
        style: ZZToastView.Style,
        duration: ToastDuration
    ) {
        self.image = image
        self.label = label
        self.style = style
        self.timing = duration
    }

    // MARK: ToastableItemProtocol

    public func getView(size: CGSize) -> AnyView {
        AnyView(
            ZZToastView(
                image: image,
                label: label
            )
        )
    }
}
