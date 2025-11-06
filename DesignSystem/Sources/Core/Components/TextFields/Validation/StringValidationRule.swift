//
//  StringValidationRule.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import Foundation

/**
    Validation rule that verify `ZZTextField` string content meet some conditions passed as a `validate` closure on initialization.
*/
public struct StringValidationRule: ValidationRuleProtocol {

    // MARK: Typealias

    public typealias DataType = String

    // MARK: Properties

    public let validationMessage: (String) -> String
    public let validate: ((String) -> Bool)

    // MARK: Init

    /**
         - Parameters:
            - validationMessage: Message to display if validate `closure` return `false`
            - validate: Validation closure
    */
    public init(validationMessage: String, validate: @escaping (String) -> Bool) {
        self.validationMessage = { _ in validationMessage }
        self.validate = validate
    }

    /**
     - Parameters:
     - validationMessage: Message to display if validate `closure` return `false`
     - validate: Validation closure
     */
    public init(validationMessage: @escaping (String) -> String, validate: @escaping (String) -> Bool) {
        self.validationMessage = validationMessage
        self.validate = validate
    }

    // MARK: - Methods

    // swiftlint:disable force_try
    public static func valueContainsByRegex(_ value: String, regex: String) -> Bool {
        let stringRange = NSRange(location: 0, length: value.utf16.count)

        let regex = try! NSRegularExpression(pattern: regex, options: .anchorsMatchLines)

        return regex.numberOfMatches(in: value, range: stringRange) != 0
    }
}
