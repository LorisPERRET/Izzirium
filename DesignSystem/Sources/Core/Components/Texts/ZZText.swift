//
//  ZZText.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 10/03/2025.
//

import SKUI
import SwiftUI

/**
    ZZText provides a text view with a customizable style. It handles non-breaking hyphen.

    ### Usage

    ```swift
    import SwiftUI
    import DesignSystem

    struct ExampleView: View {

        var body: some View {
             ZZText(
                "This is an example",
                 font: .bodyLarge,
                 foregroundColor: .secondary,
                 multilineTextAlignment: .center,
                 lineLimit: 1,
                 frameAlignment: .center
             )
        }
    }
    ```
*/
public struct ZZText: View {

    // MARK: - Constants

    private enum Constants {

        static let disableForegroundColor = Color.neutralLowest
    }

    // MARK: Properties

    @Environment(\.isEnabled) private var isEnabled

    private let text: String
    private let font: FontStyle?
    private let foregroundColor: Color?
    private let withBaselineModifier: Bool
    private let multilineTextAlignment: TextAlignment
    private let frameAlignment: Alignment?
    private let lineLimit: Int?
    private let isSelected: Bool
    private let maxWidth: Bool
    private let fixedSize: Bool

    private var textToDisplay: LocalizedStringKey {
        var textCopy = text
        if textCopy.containsSubscript {
            // If Font does not properly handle subscript (for instance in CO₂),
            // we need to add a new line for it to be entirely displayed
            // For example: EdoSZ ❌, Gotham ✅
            textCopy += "\n"
        }
        return LocalizedStringKey(stringLiteral: textCopy.replacingOccurrences(of: "-", with: "\u{2011}"))
    }

    private var foregroundColorStyle: Color? {
        isEnabled ? foregroundColor : Constants.disableForegroundColor
    }

    // MARK: View

    public var body: some View {
        textWithFont
            .applyIfLet(foregroundColorStyle) { textView, foregroundColorStyle in
                textView
                    .foregroundStyle(foregroundColorStyle)
            }
            .multilineTextAlignment(multilineTextAlignment)
            .lineLimit(lineLimit)
            .applyIfLet(frameAlignment) { content, alignment in
                content
                    .frame(maxWidth: maxWidth ? .infinity : nil, alignment: alignment)
            } else: { content in
                content
                    .frame(maxWidth: maxWidth ? .infinity : nil)
            }
            .applyIf(fixedSize) { content in
                content
                    .fixedSize(horizontal: false, vertical: true)
            }
            .tint(foregroundColor) // to prevent urls and emails from having a different accent color
    }

    // MARK: Subviews

    private var textWithFont: some View {
        Text(textToDisplay) // swiftlint:disable:this forbidden_native_text
            .applyIfLet(font) { content, font in
                content
                    .zzFont(font, withBaselineModifier: withBaselineModifier)
                    .applyIf(text.containsSubscript) { content in
                        // Some Font does not properly handle subscript (for instance in CO₂) --> the other part of the solution: removing a bottom padding to compensate the new line which has been added
                        content
                            .padding(.bottom, -font.lineHeight)
                    }
            }
    }

    // MARK: Init

    /// ZZText provides a text view with a customizable style.
    /// - Parameters:
    ///   - text: the text to display
    ///   - font: text font
    ///   - foregroundColor: text color. Pass nil if value is set by a parent view.
    ///   - multilineTextAlignment:  the alignment of a text view that contains multiple lines of text
    ///   - lineLimit: maximum number of lines that text can occupy in this view.
    ///   - frameAlignment: the alignment of this view inside the resulting frame
    ///   - isSelected: indicates whether the text is displayed on a selected styled component
    ///   - maxWidth: indicates whether the text must take the maximum width possible
    public init(
        _ text: String,
        font: FontStyle? = .textBase,
        foregroundColor: Color? = nil,
        withBaselineModifier: Bool = true,
        multilineTextAlignment: TextAlignment = .leading,
        lineLimit: Int? = nil,
        frameAlignment: Alignment? = .leading,
        isSelected: Bool = false,
        maxWidth: Bool = true,
        fixedSize: Bool = true
    ) {
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
        self.multilineTextAlignment = multilineTextAlignment
        self.lineLimit = lineLimit
        self.frameAlignment = frameAlignment
        self.withBaselineModifier = withBaselineModifier
        self.isSelected = isSelected
        self.maxWidth = maxWidth
        self.fixedSize = fixedSize
    }
}

#if DEBUG

struct ZZText_Previews: PreviewProvider {

    private struct NonBreakingHyphenView: View {

        // MARK: Properties

        @State private var width = 100.0

        // MARK: View

        var body: some View {
            ZZText("This is an-example with hyphen (to test non breaking hyphen)")
                .frame(width: width)

            Slider(value: $width, in: 100...200) // swiftlint:disable:this no_magic_numbers
        }
    }

    static var previews: some View {
        ScrollView {
            VStack(spacing: MagicUnit.mu100.rawValue) {
                ZZText("This is an example")

                ZZText("With subscript: CO₂", font: .h3)

                ZZText("With superscript: E=mc²", font: .h3)

                ZZText("Without subscript", font: .h3)

                ZZText("With subscript: CO₂", font: .labelS)

                ZZText("With superscript: E=mc²", font: .labelS)

                ZZText("Without subscript", font: .labelS)

                ZZText("This is an example with an email: test@test.com")

                ZZText("This is an example with custom font", font: .textL)

                ZZText("This is an example with custom foreground color", foregroundColor: .primaryMedium)

                ZZText(
                    "This is an example with custom multilineTextAlignment and line limit",
                    multilineTextAlignment: .center,
                    lineLimit: 1
                )
                    .frame(width: 150) // swiftlint:disable:this no_magic_numbers

                ZZText("This is an example with custom frame alignment", frameAlignment: .trailing)

                ZZText("This is an-example with hyphen (to test non breaking hyphen)")

                ZZText("This is an example with **markdown**", font: nil)

                ZZText("This is a disabled text example")
                    .disabled(true)

                ZZText("This is a selected, disabled text example", isSelected: true)
                    .disabled(true)

                NonBreakingHyphenView()
            }
            .padding(.horizontal, .mu100)
        }
    }
}

#endif
