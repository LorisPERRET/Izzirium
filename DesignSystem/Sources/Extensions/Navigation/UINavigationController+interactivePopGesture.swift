//
//  UINavigationController+interactivePopGesture.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import UIKit

// Enable gesture when .navigationBarBackButtonHidden(true)
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {

    // swiftlint:disable:next override_in_extension
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
