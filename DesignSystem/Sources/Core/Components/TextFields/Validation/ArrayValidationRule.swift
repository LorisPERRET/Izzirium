//
//  ArrayValidationRule.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

/**
 Validation rule that ensure `[DataType]` meet some conditions passed as a `validate` closure on initialization.
 */
public struct ArrayValidationRule<T>: ValidationRuleProtocol where T: Equatable {

    // MARK: Typealias

    public typealias DataType = [T]

    // MARK: Properties

    public let validationMessage: (String) -> String
    public let validate: ((DataType) -> Bool)

    // MARK: Init

    /**
         - Parameters:
             - validationMessage: Message to display if validate `closure` return `false`
             - validate: Validation closure
     */
    public init(validationMessage: String, validate: @escaping (DataType) -> Bool) {
        self.validationMessage = { _ in validationMessage }
        self.validate = validate
    }
}
