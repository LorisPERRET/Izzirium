//
//  ValidationRuleProtocol.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import Foundation

/**
    Protocol to conforms to when defining a new custom validation rule.
    See ``StringValidationRule`` and ``OptionalValidationRule`` as implementation example.
*/
public protocol ValidationRuleProtocol {

    associatedtype DataType: Equatable

    var validationMessage: (String) -> String { get }

    var validate: ((DataType) -> Bool) { get }
}
