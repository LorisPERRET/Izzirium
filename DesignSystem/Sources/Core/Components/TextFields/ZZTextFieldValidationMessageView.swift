//
//  ZZTextFieldValidationMessageView.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import Foundation
import SwiftUI

struct ZZTextFieldValidationMessageView: View {

    // MARK: Properties

    private let validationMessage: ZZTextFieldValidationMessage

    // MARK: View

    var body: some View {
        HStack(spacing: MagicUnit.mu050.rawValue) {
            if validationMessage.hasCheckMark {
                if validationMessage.state == .valid {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.successHight)
                        .frame(width: MagicUnit.mu075.rawValue, height: MagicUnit.mu075.rawValue)
                } else {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.neutralLow)
                        .frame(width: MagicUnit.mu075.rawValue, height: MagicUnit.mu075.rawValue)
                }
            }

            ZZText(
                validationMessage.message,
                font: .textS,
                foregroundColor: validationMessage.state == .invalid ? .dangerMedium : .neutralMedium,
                withBaselineModifier: false,
                frameAlignment: .leading
            )
        }
    }

    // MARK: Init

    init(validationMessage: ZZTextFieldValidationMessage) {
        self.validationMessage = validationMessage
    }
}
