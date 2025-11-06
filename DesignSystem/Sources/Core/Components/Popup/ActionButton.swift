//
//  ActionButton.swift
//  DesignSystem
//
//  Created by Loris Perret on 27/10/2025.
//

import Foundation

public struct ActionButton: Identifiable {

    public enum ActionButtonType {

        case primary
        case secondary
        case cancel
        case destructive

        var theme: ZZButton.Theme {
            switch self {
            case .primary: .primary
            case .secondary: .secondary
            case .cancel: .tertiary
            case .destructive: .destructive
            }
        }
    }

    // MARK: - Properties

    public let id = UUID()

    public let title: String
    public let type: ActionButtonType
    public let action: () async -> Void

    // MARK: - Init

    public init(title: String, type: ActionButtonType, action: @escaping () async -> Void) {
        self.title = title
        self.type = type
        self.action = action
    }
}
