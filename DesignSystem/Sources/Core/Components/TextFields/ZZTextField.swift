//
//  ZZTextField.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import SwiftUI

// swiftlint:disable file_length forbidden_native_padding_modifier no_magic_numbers type_body_length
/**
    ZZDesignSystem provides multiples types of TextFields : `email`, `password`, `text` and `textArea`.

    - The length of the input can be limited thanks to the maxLength parameter.
    - A unit can be added to this field.
    - The input can be formatted thanks to a given mask: every "#" of this mask will be replaced by the corresponding character within the string entered by the user, and every other character will be added to the original string (example: the following mask "###:###:###" applied to the following string "123456789" gives this result: "123:456:789"). Attention: the mask must contain only one separator type; otherwise, the first found separator will be chosen as separator and every other separator will be replaced by the latter.
*/
public struct ZZTextField: View {

    // MARK: Properties

    @Environment(\.isEnabled) private var isEnabled

    @Binding private var value: String
    @Binding private var valueToObserveToTriggerValidation: String

    @State private var valueToDisplay: String

    @State private var hasBeenFocusedOut = false
    @State private var validationMessages: [ZZTextFieldValidationMessage]
    @FocusState private var isFocused: Bool
    @State private var textHeight: CGFloat = 0

    private let label: String?
    private let placeholder: String?
    private let maxLength: Int?
    private let unit: String?
    private let helpText: String?
    private let helpTitle: String?
    private let withClearButton: Bool
    private let backgroundColor: Color

    private var type: FieldType
    private let textContentType: UITextContentType?
    private let rules: [StringValidationRule]
    private var hasBeenSubmitted: Bool
    private let validationStyle: ValidationStyle
    private let validationCheckmarkAlignment: ValidationCheckAlignment?

    private var textBinding: Binding<String> {
        $value
    }

    // MARK: View

    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: MagicUnit.mu025.rawValue
        ) {
            labelInput

            HStack {
                input

                if !rules.isEmpty && validationCheckmarkAlignment == .textfield {
                    if isValid {
                        Image(systemName: "checkmark.circle.fill")
                            .renderingMode(.template)
                            .foregroundStyle(iconValidationColor)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .renderingMode(.template)
                            .foregroundStyle(iconValidationColor)
                    }
                }
            }

            validationMessage
        }
        .frame(minWidth: MagicUnit.zero.rawValue, maxWidth: .infinity)
        .onAppear {
            if validationStyle == .alwaysDisplayed {
                validate(
                    value,
                    hasBeenFocusedOut: hasBeenFocusedOut,
                    hasBeenSubmitted: hasBeenSubmitted,
                    computeValidation: false
                )
            }
        }
    }

    // MARK: Private computed variables

    private var isValid: Bool {
        !validationMessages.contains { $0.state == .invalid }
    }

    private var iconValidationColor: Color {
        if validationMessages.contains(where: { $0.state == .invalid }) {
            return Color.dangerMedium
        } else if !validationMessages.contains(where: { $0.state != .valid }) {
            return Color.successMedium
        } else {
            return Color.neutralLow
        }
    }

    private var strokeStyle: ZZStrokeStyle {
        isFocused ? .medium : .small
    }

    // MARK: Subviews

    @ViewBuilder
    private var input: some View {
        HStack(
            alignment: .center,
            spacing: MagicUnit.zero.rawValue
        ) {
            fieldView
        }
        .onChange(of: valueToObserveToTriggerValidation) { _, _ in
            onChangeOf(value: value, hasBeenFocusedOut: hasBeenFocusedOut, hasBeenSubmitted: hasBeenSubmitted)
        }
        .onChange(of: value) { _, newValue in
            onChangeOf(value: newValue, hasBeenFocusedOut: hasBeenFocusedOut, hasBeenSubmitted: hasBeenSubmitted)
        }
        .onChange(of: hasBeenFocusedOut) { _, newHasBeenFocusedOut in
            onChangeOf(value: value, hasBeenFocusedOut: newHasBeenFocusedOut, hasBeenSubmitted: hasBeenSubmitted)
        }
        .onChange(of: hasBeenSubmitted) { _, newHasBeenSubmitted in
            onChangeOf(value: value, hasBeenFocusedOut: hasBeenFocusedOut, hasBeenSubmitted: newHasBeenSubmitted)
        }
        .focused($isFocused)
        .zzFont(
            .textBase,
            withBaselineModifier: false
        )
        .foregroundStyle(isEnabled ? Color.neutralHighter : Color.neutralLower)
        .accessibilityAddTraits(.isButton)
        .frame(
            minHeight: MagicUnit.mu300.rawValue
        )
        .padding(.horizontal, .mu100)
        .background(
            backgroundView
        )
        .textFieldStyle(.plain)
        .keyboardType(type.keyboardType)
        .autocapitalization(type.autocapitalization)
        .disableAutocorrection(!type.autocorrection)
        .textContentType(textContentType)
        .onChange(of: isFocused) { _, isFocused in
            if !isFocused {
                self.hasBeenFocusedOut = true
            }
        }
    }

    @ViewBuilder
    private var textAreaPlaceholderView: some View {
        if value.isEmpty {
            ZZText(
                placeholder ?? "",
                font: .textL,
                foregroundColor: .neutralLow,
                withBaselineModifier: false
            )
            .allowsHitTesting(false)
            .padding(.leading, 5)
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        RoundedRectangle(
            cornerRadius: type != .textArea ? RadiusStyle.full.rawValue : RadiusStyle.small.rawValue,
            style: .continuous
        )
        .fill(
            isValid ? backgroundColor : .dangerLowest,
            strokeBorder: isValid ? (isEnabled ? Color.neutralLower : Color.neutralLowest) : .dangerMedium,
            lineWidth: .small
        )
        .frame(minHeight: MagicUnit.mu300.rawValue)
    }

    @ViewBuilder
    private var labelInput: some View {
        if let label {
            ZZText(
                label,
                font: .textMediumS,
                maxWidth: false
            )
        }
    }

    @ViewBuilder
    private var validationMessage: some View {
        Group {
            if !validationMessages.isEmpty {
                VStack(
                    alignment: .leading,
                    spacing: MagicUnit.mu025.rawValue
                ) {
                    ForEach(validationMessages, id: \.self) { message in
                        ZZTextFieldValidationMessageView(validationMessage: message)
                    }
                }
            }
        }
    }

    private var passwordView: some View {
        SecureInputView("", text: textBinding)
            .placeholder(
                placeholder ?? "",
                when: textBinding.wrappedValue.isEmpty,
                foregroundColor: .neutralLow
            )
    }

    private var growingTextAreaView: some View {
        TextField("", text: textBinding, axis: .vertical)
            .scrollContentBackground(.hidden)
            .lineLimit(3...)
            .placeholder(
                placeholder ?? "",
                when: textBinding.wrappedValue.isEmpty,
                alignment: .topLeading,
                foregroundColor: isEnabled ? .neutralMedium : .neutralLower
            )
            .padding(EdgeInsets(top: 8, leading: -5, bottom: 8, trailing: -5))
    }

    private var textAreaView: some View {
        TextEditor(text: textBinding)
            .scrollContentBackground(.hidden)
            .frame(height: MagicUnit.mu900.rawValue)
            .overlay(textAreaPlaceholderView, alignment: .topLeading)
            .padding(EdgeInsets(top: 8, leading: -5, bottom: 8, trailing: -5))
    }

    private var simpleTextView: some View {
        HStack(spacing: MagicUnit.mu025.rawValue) { // swiftlint:disable:this closure_body_length
            let placeholder = placeholder ?? ""
            TextField("", text: textBinding)
                .placeholder(
                    placeholder,
                    when: textBinding.wrappedValue.isEmpty,
                    alignment: .leading,
                    foregroundColor: isEnabled ? .neutralMedium : .neutralLower
                )
                .multilineTextAlignment(.leading)
                .applyIfLet(unit) { content, unit in
                    HStack {
                        content

                        // warning: do not use ZZText here (specific configuration)
                        Text("\(unit)") // swiftlint:disable:this forbidden_native_text
                            .padding(.leading, .mu025)
                            .hidden()
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        HStack(spacing: .zero) {
                            // warning: do not use ZZText here (specific configuration)
                            Text(textBinding.wrappedValue) // swiftlint:disable:this forbidden_native_text
                                .hidden()

                            // warning: do not use ZZText here (specific configuration)
                            Text("\(unit)") // swiftlint:disable:this forbidden_native_text
                                .padding(.leading, .mu025)
                                .frame(alignment: .trailing)
                                .foregroundStyle(textBinding.wrappedValue.isEmpty ? .clear : (isEnabled ? Color.neutralHighter : Color.neutralLower))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    )
                }

            if withClearButton && !value.isEmpty {
                Button {
                    value = ""
                    valueToDisplay = ""
                } label: {
                    Image("xmark.circle")
                }
                .foregroundStyle(isEnabled ? Color.neutralHighter : Color.neutralLower)
            }
        }
        .frame(minWidth: MagicUnit.zero.rawValue, maxWidth: .infinity)
    }

    @ViewBuilder
    private var fieldTypeView: some View {
        switch type {
        case .textArea:
            growingTextAreaView
        case .password:
            passwordView
        case .email, .numeric, .text:
            simpleTextView
        }
    }

    @ViewBuilder
    private var fieldView: some View {
        fieldTypeView
            .onChange(of: textBinding.wrappedValue) { _, newValue in
                if let maxLength {
                    self.value = newValue.limitLength(maxLength)
                }
            }
    }

    // MARK: Init

    /// Creates a new ZZTextField View
    ///
    /// - Parameters:
    ///   - value: The text to display and edit.
    ///   - hasBeenSubmitted: Indicates if text field has been submitted
    ///   - type: Text field type ``ZZTextField/FieldType``
    ///   - label: Purpose of the field placed above the field
    ///   - maxLength: Maximum number of character of field
    ///   - unit: unit description
    ///   - helpText: helpText description
    ///   - helpTitle: helpText title
    ///   - placeholder: A text representing the prompt of the text field which provides users with guidance on what to type into the text field.
    ///   - withClearButton: Indicate to whether show a clear button or not
    ///   - textContentType: Sets the text content type for this view, which the system uses to offer suggestions while the user enters text
    ///   - rules: Validation rules use to show a error message if a rule is not validate
    ///   - validationStyle: Determine when validation will happen
    ///   - validationCheckmarkAlignment: Determine where validation will appear
    ///   - valueToObserveToTriggerValidation: Binding of another `String` which will be used to trigger validations rules
    public init(
        value: Binding<String>,
        hasBeenSubmitted: Bool,
        type: FieldType,
        label: String?,
        backgroundColor: Color = .clear,
        maxLength: Int? = nil,
        unit: String? = nil,
        helpText: String? = nil,
        helpTitle: String? = nil,
        placeholder: String? = nil,
        withClearButton: Bool = false,
        textContentType: UITextContentType? = nil,
        rules: [StringValidationRule] = [],
        validationStyle: ValidationStyle = .alwaysDisplayed,
        validationCheckmarkAlignment: ValidationCheckAlignment? = .textfield,
        valueToObserveToTriggerValidation: Binding<String> = .constant("")
    ) {
        self._value = value
        self.valueToDisplay = value.wrappedValue
        self.hasBeenSubmitted = hasBeenSubmitted
        self.type = type
        self.label = label
        self.backgroundColor = backgroundColor
        self.maxLength = maxLength
        self.unit = unit
        self.helpText = helpText
        self.helpTitle = helpTitle
        self.placeholder = placeholder
        self.withClearButton = withClearButton
        self.textContentType = textContentType
        self.rules = rules
        self.validationStyle = validationStyle
        self.validationCheckmarkAlignment = validationCheckmarkAlignment
        self._validationMessages = State(initialValue: [])
        self._valueToObserveToTriggerValidation = valueToObserveToTriggerValidation
    }

    // MARK: Private methods

    private func onChangeOf(value: String, hasBeenFocusedOut: Bool, hasBeenSubmitted: Bool) {
        clearValidationMessages()

        switch validationStyle {
        case .alwaysDisplayed:
            validate(value, hasBeenFocusedOut: hasBeenFocusedOut, hasBeenSubmitted: hasBeenSubmitted)
        case .submit:
            if hasBeenSubmitted || hasBeenFocusedOut {
                validate(value, hasBeenFocusedOut: hasBeenFocusedOut, hasBeenSubmitted: hasBeenSubmitted)
            }
        }
    }

    private func clearValidationMessages() {
        validationMessages.removeAll()
    }

    private func validate(
        _ value: String,
        hasBeenFocusedOut: Bool,
        hasBeenSubmitted: Bool,
        computeValidation: Bool = true
    ) {
        clearValidationMessages()

        rules.forEach { rule in
            let alwaysDisplay = validationStyle == .alwaysDisplayed
            var state: ZZTextFieldValidationMessage.ValidationState = .neutral
            var ruleInError = false

            if computeValidation {
                let isValid = rule.validate(value)
                if isValid {
                    state = .valid
                } else {
                    if alwaysDisplay {
                        state = .invalid
                    } else if hasBeenSubmitted || hasBeenFocusedOut {
                        state = .invalid
                    }
                }
            }

            if state == .invalid {
                ruleInError = true
            }

            if ruleInError || alwaysDisplay {
                validationMessages.append(
                    ZZTextFieldValidationMessage(
                        state: state,
                        message: rule.validationMessage(value),
                        hasCheckMark: validationCheckmarkAlignment == .rules
                    )
                )
            }
        }
    }
}

#if DEBUG

struct ZZTextField_Previews: PreviewProvider {

    struct SimpleTextFieldPreview: View {

        @State var value: String
        let withClearButton: Bool

        init(value: String = "", withClearButton: Bool = false) {
            self.value = value
            self.withClearButton = withClearButton
        }

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .text,
                label: "Name",
//                helpText: "Your lastname",
                placeholder: "Type your lastname",
                withClearButton: withClearButton
            )
        }
    }

    struct SimpleTextFieldWithUnitPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .numeric,
                label: "Text field with unit",
                unit: "km",
                placeholder: "Type a distance"
            )
        }
    }

    struct SimpleTextFieldWithUnitAndMaxLengthPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .numeric,
                label: "Text field with unit and maxLength",
                maxLength: 10,
                unit: "km",
                placeholder: "Type a distance"
            )
        }
    }

    struct SimpleTextFieldWithUnitAndMaskPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .numeric,
                label: "Text field with unit and mask",
                unit: "km",
                placeholder: "Type a distance"
            )
        }
    }

    struct SimpleTextFieldWithUnitAndClearButtonPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .text,
                label: "Text field with unit and clear button",
                unit: "km",
                placeholder: "Type a distance",
                withClearButton: true
            )
        }
    }

    struct DisabledTextFieldPreview: View {

        var body: some View {
            ZZTextField(
                value: .constant("Value"),
                hasBeenSubmitted: false,
                type: .text,
                label: "Disabled",
//                helpText: "Help text",
                placeholder: "Type your lastname"
            )
            .disabled(true)
        }
    }

    struct DisabledTextFieldWithPlaceholderPreview: View {

        var body: some View {
            ZZTextField(
                value: .constant(""),
                hasBeenSubmitted: false,
                type: .text,
                label: "Disabled without value",
//                helpText: "Help text",
                placeholder: "Placeholder"
            )
            .disabled(true)
        }
    }

    struct EmailTextFieldPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .email,
                label: "Email",
                placeholder: "Type your email"
            )
        }
    }

    struct SecureTextFieldPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .password,
                label: "Secure text field"
            )
        }
    }

    struct SecureTextFieldWithMaxLengthPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .password,
                label: "Secure text field with max length",
                maxLength: 5
            )
        }
    }

    struct TextFieldWithErrorPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .text,
                label: "Label",
                rules: [ZZTextField_Previews.maxLengthHeightRule]
            )
        }
    }

    struct TextFieldWithMaskPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .text,
                label: "Text field with mask"
//                mask: "###-###-###"
            )
        }
    }

    struct TextFieldWithMaxLengthPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .text,
                label: "Text field with max length (5)",
                maxLength: 5
            )
        }
    }

    struct TextFieldWithMaxLengthAndMaskPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .text,
                label: "Text field with max length (5) + mask",
//                mask: "###-###-###",
                maxLength: 5
            )
        }
    }

    struct TextAreaTextFieldPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .textArea,
                label: "Text area",
                placeholder: "Type your long text",
                rules: [ZZTextField_Previews.maxLengthHeightRule]
            )
        }
    }

    struct TextAreaTextFieldWithMaskPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .textArea,
                label: "Text area with mask",
//                mask: "###-###-###",
                placeholder: "Type your long text"
            )
        }
    }

    struct TextAreaTextFieldWithMaxLengthPreview: View {

        @State var value = ""

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: true,
                type: .textArea,
                label: "Text area with max length (10)",
                maxLength: 10,
                placeholder: "Type your long text"
            )
        }
    }

    struct TextFieldWithArrayOfStringValidationAlwaysDisplay: View {

        @State var value = ""

        let rules = [
            ZZTextField_Previews.maxLengthHeightRule,
            StringValidationRule(validationMessage: "Your text must have at least 3 characters") { $0.count > 2 },
            StringValidationRule(validationMessage: "Your text is not a valid email") { $0.contains("@") },
            StringValidationRule(validationMessage: "Your text must have a digit") { value in
                StringValidationRule.valueContainsByRegex(value, regex: ".*[0-9]+.*")
            },
            StringValidationRule(validationMessage: "Your text must have a special character") { value in
                StringValidationRule.valueContainsByRegex(value, regex: ".*[\\-_+$%#&!?=]+.*")
            },
            StringValidationRule(validationMessage: "Your text must have a uppercased character") { value in
                StringValidationRule.valueContainsByRegex(value, regex: ".*[A-Z]+.*")
            }
        ]

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .text,
                label: "Label with always displayed validation rules",
//                helpText: "Your password must contains :",
                rules: rules,
                validationStyle: .alwaysDisplayed
            )
        }
    }

    struct TextFieldWithSubmitValidationRule: View {

        @State var value = ""

        let rules = [
            StringValidationRule(validationMessage: "Your input cannot be empty") { $0.isEmpty == false }
        ]

        var body: some View {
            ZZTextField(
                value: $value,
                hasBeenSubmitted: false,
                type: .text,
                label: "Input with validation checked on submit/lost focus",
                rules: rules,
                validationStyle: .submit
            )
        }
    }

    static let maxLengthHeightRule = StringValidationRule(validationMessage: "Your text must be less than 8 characters") { $0.count <= 8 }

    static var previews: some View {
        ScrollView {
            VStack {
                SimpleTextFieldPreview()
                SimpleTextFieldWithUnitPreview()
                SimpleTextFieldWithUnitAndMaxLengthPreview()
                SimpleTextFieldWithUnitAndMaskPreview()
                SimpleTextFieldWithUnitAndClearButtonPreview()
                SimpleTextFieldPreview(value: "Clear", withClearButton: true)
                DisabledTextFieldPreview()
                DisabledTextFieldWithPlaceholderPreview()
                SecureTextFieldPreview()
                SecureTextFieldWithMaxLengthPreview()
                TextFieldWithErrorPreview()
                TextFieldWithMaskPreview()
                TextFieldWithMaxLengthPreview()
                TextFieldWithMaxLengthAndMaskPreview()
                EmailTextFieldPreview()
                TextAreaTextFieldPreview()
                TextAreaTextFieldWithMaskPreview()
                TextAreaTextFieldWithMaxLengthPreview()
                TextFieldWithArrayOfStringValidationAlwaysDisplay()
                TextFieldWithSubmitValidationRule()
            }
        }
    }
}

#endif
