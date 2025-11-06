//
//  ZZTextField+FieldType.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import SwiftUI

extension ZZTextField {

    /// Content type of ``ZZTextField``
    public enum FieldType {

        case email
        case numeric
        case password
        case text
        case textArea

        var secured: Bool {
            switch self {
            case .password:
                return true
            default:
                return false
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            case .numeric:
                return .numberPad
            default:
                return .default
            }
        }

        var autocapitalization: UITextAutocapitalizationType {
            switch self {
            case .text, .textArea:
                return .sentences
            default:
                return .none
            }
        }

        var autocorrection: Bool {
            switch self {
            case .text, .textArea:
                return true
            default:
                return false
            }
        }
    }
}
