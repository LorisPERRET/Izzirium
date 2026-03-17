//
//  ShadowStyle.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import SwiftUI

// swiftlint:disable no_magic_numbers

/**

 Shadows are available in 3 sizes : **small**, **regular** and **large**.

 ### Usage

 To ensure applications to use right shadows, our linter disallow some native SwiftUI usage like :

 **Don't :**

 ```swift
 . shadow(
     color: Color
         .black
         .opacity(0.5),
     radius: 24,
     x: 0,
     y: 12
 )
 ```

 Instead, Design System provides some helpful extensions :

 **Do :**

 ```swift
 .zzShadow(.medium) // ShadowStyle.medium
 ```
 */
public enum ShadowStyle {

    case small
    case medium
    case large
    case none

    var radiusStyle: RadiusStyle {
        switch self {
        case .small:
            .small
        case .medium:
            .medium
        case .large:
            .large
        case .none:
            .zero
        }
    }

    var yOffset: CGFloat {
        switch self {
        case .small:
            1
        case .medium:
            2
        case .large:
            4
        case .none:
            .zero
        }
    }
}
