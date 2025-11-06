//
//  ZZNumericText.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 10/03/2025.
//

import SKUI
import SwiftUI

/**
    `ZZNumericText` displays a number (Int, Double, etc...) with optional unit and animation.

     ### Usage

     ```swift
     import SwiftUI

     struct ContentView: View {

        @State private var value = 42.0

         var body: some View {
             ZZNumericText(
                 text: value.formatted(.number),
                 unit: "m2",
                 withAnimation: true
             )
         }
     }
     ```

    > `withAnimation` should only be to true for values that are not directly controled by user inputs to avoid animation delay frustration.
*/
public struct ZZNumericText: View {

    // MARK: - Constants

    private enum Constants {

        static let enabledForegroundColor = Color.neutralMedium
        static let disabledForegroundColor = Color.neutralLowest
    }

    // MARK: Properties

    @Environment(\.isEnabled) private var isEnabled

    private let text: String
    private let unit: String?
    private let fontStyle: FontStyle
    private let withAnimation: Bool

    // MARK: View

    public var body: some View {
        HStack(spacing: MagicUnit.mu025.rawValue) {
            Text(text) // swiftlint:disable:this forbidden_native_text
                .kerning(-1)
                .font(fontStyle.font)
                .monospaced()
                .animation(withAnimation ? .default : nil, value: text)
                .applyIf(withAnimation) { textView in
                    textView
                        .contentTransition(.numericText())
                }

            if let unit {
                Text(unit) // swiftlint:disable:this forbidden_native_text
                    .font(fontStyle.font)
            }
        }
        .foregroundStyle(
            isEnabled ? Constants.enabledForegroundColor : Constants.disabledForegroundColor
        )
    }

    // MARK: Init

    /// Creates a new ZZNumericText View
    ///
    /// - Parameters:
    ///   - text: Text to display
    ///   - unit: Unit associated to text, default is `nil`
    ///   - withAnimation: `true` to use `.contentTransition(.numericText())` on text, default is `false`
    public init(
        text: String,
        unit: String? = nil,
        font: FontStyle = FontStyle.textBoldBase,
        withAnimation: Bool = false
    ) {
        self.text = text
        self.unit = unit
        self.fontStyle = font
        self.withAnimation = withAnimation
    }
}

#if DEBUG

struct ZZNumericText_Previews: PreviewProvider {

    struct Preview: View {

        // MARK: Properties

        @State private var value = 42.0

        // MARK: View

        var body: some View {
            ScrollView {
                VStack(spacing: MagicUnit.mu100.rawValue) {
                    defaultSection
                    withUnitSection
                    withUnitAndAnimationSection
                    changeValueSection
                }
            }
            .background(Color.neutralLowest)
        }

        // MARK: Subviews

        private var defaultSection: some View {
            VStack {
                ZZText("Default")
                HStack {
                    Spacer()

                    VStack(alignment: .trailing) {
                        ZZNumericText(
                            text: value.formatted(.number)
                        )
                        .zzFont(.textBoldL)
                    }
                }
                .cardBackground(minHeight: nil)
            }
            .padding(.horizontal, MagicUnit.mu100)
        }

        private var withUnitSection: some View {
            VStack {
                ZZText("With unit")
                HStack {
                    Spacer()

                    VStack(alignment: .trailing) {
                        let fontStyles: [FontStyle] = [
                            .textS,
                            .textBoldS,
                            .textBase,
                            .textBoldBase,
                            .textL,
                            .textBoldL
                        ]

                        ForEach(fontStyles, id: \.self) { fontStyle in
                            ZZNumericText(
                                text: value.formatted(.number),
                                unit: "%",
                                font: fontStyle
                            )
                        }
                    }
                }
                .cardBackground(minHeight: nil)
            }
            .padding(.horizontal, MagicUnit.mu100)
        }

        private var withUnitAndAnimationSection: some View {
            VStack {
                ZZText("With unit and animation")

                HStack {
                    Spacer()

                    ZZNumericText(
                        text: value.formatted(.number),
                        unit: "m2",
                        withAnimation: true
                    )
                    .zzFont(.textBoldL)
                }
                .cardBackground(minHeight: nil)
            }
            .padding(.horizontal, MagicUnit.mu100)
        }

        private var changeValueSection: some View {
            VStack {
                ZZText("With unit and animation")

                Slider(
                    value: $value,
                    in: 0...100,
                    step: 1
                )
                .tint(Color.primaryMedium)
                .cardBackground(minHeight: nil)
            }
            .padding(.horizontal, MagicUnit.mu100)
        }
    }

    static var previews: some View {
        Preview()
    }
}

#endif
