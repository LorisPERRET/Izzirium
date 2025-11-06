//
//  ZZCard.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 06/03/2025.
//

import Foundation
import SwiftUI

/**

 A "card" layout container to provide contents with title & subtitle.
 Container accepts custom view through @ViewBuilder parameters for :
 - body  : card's body
 The container embeds also a closure for "tap gesture" to trigger code on user tap.

 ### Usage

 ```
 struct Sample: View {

     var body: some View {
         VStack {
             ZZCard(
                 bodyContent: {
                    Color.light100
                        .frame(height: height)
                 },
                 action: nil,
                 backgroundColor: Color.primaryMedium
             )
         }
     }
 }

 ```
 */
public struct ZZCard<BodyContent: View>: View {

    // MARK: - Theme

    private struct Theme {

        let foregroundColor = Color.neutralHightest
        let radius = RadiusStyle.medium
        let backgroundColor = Color.lightHightest
    }

    // MARK: Properties

    private let bodyContent: () -> BodyContent
    private let backgroundColor: Color?
    private let action: (() -> Void)?

    private let theme = Theme()

    // MARK: View

    public var body: some View {
        if let action {
            Button {
                action()
            } label: {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }

    // MARK: - Subviews

    private var content: some View {
        VStack(
            alignment: .leading
        ) {
            bodyContent()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cardBackground(
            maxHeight: nil,
            alignment: .center,
            color: backgroundColor ?? theme.backgroundColor,
            horizontalPadding: .mu100,
            verticalPadding: .mu075,
            radius: theme.radius
        )
        .foregroundStyle(theme.foregroundColor)
    }

    // MARK: Init

    public init(
        @ViewBuilder bodyContent: @escaping () -> BodyContent = { EmptyView() },
        action: (() -> Void)?,
        backgroundColor: Color? = nil
    ) {
        self.bodyContent = bodyContent
        self.action = action
        self.backgroundColor = backgroundColor
    }
}

#if DEBUG

#Preview { // swiftlint:disable:this closure_body_length

    let height = MagicUnit.mu200.rawValue

    VStack(spacing: MagicUnit.mu100.rawValue) {
        ZZCard(
            bodyContent: {
                Color.primaryMedium
                    .frame(height: height)
            },
            action: nil
        )

        ZZCard(
            bodyContent: {
                Color.lightHightest
                    .frame(height: height)
            },
            action: nil,
            backgroundColor: Color.primaryMedium
        )

        ZZCard(
            bodyContent: {
                VStack(alignment: .leading, spacing: MagicUnit.mu050.rawValue) {
                    ZZText(
                        "Title",
                        font: .textBoldBase
                    )
                    ZZText(
                        "Description",
                        font: .textS
                    )
                }
            }, action: nil
        )
    }
    .padding(.horizontal, .mu100)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.orange)
}

#endif
