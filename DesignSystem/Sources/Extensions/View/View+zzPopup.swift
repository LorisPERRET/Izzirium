//
//  View +zzPopup.swift
//  DesignSystem
//
//  Created by JC Neboit on 16/10/2025.
//

import PopupView
import SwiftUI

struct ZZPopupModifier: ViewModifier {

    // MARK: Properties

    @Binding var showPopup: Bool

    let title: String
    let subtitle: String?
    let buttons: () -> [ActionButton]
    let alignment: ZZPopupView.ButtonAlignment

    private let opacity = 0.5

    // MARK: ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $showPopup) {
                ZZPopupView(
                    title: title,
                    subtitle: subtitle,
                    buttons: buttons(),
                    alignment: alignment
                )
            } customize: { view in
                view
                    .appearFrom(.centerScale)
                    .backgroundColor(Color.black.opacity(opacity))
                    .allowTapThroughBG(false)
                    .closeOnTapOutside(true)
            }
    }
}

extension View {

    // swiftlint:disable function_default_parameter_at_end

    public func zzPopup(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        buttons: @autoclosure @escaping () -> [ActionButton],
        alignment: ZZPopupView.ButtonAlignment = .horizontal
    ) -> some View {
        modifier(
            ZZPopupModifier(
                showPopup: isPresented,
                title: title,
                subtitle: subtitle,
                buttons: buttons,
                alignment: alignment
            )
        )
    }

    @ViewBuilder
    public func zzPopup<T: Identifiable>(
        item: Binding<T?>,
        title: String,
        subtitle: String? = nil,
        alignment: ZZPopupView.ButtonAlignment = .horizontal,
        buttons: @escaping (T) -> [ActionButton]
    ) -> some View {
        self.zzPopup(
            isPresented: Binding(
                get: {
                    item.wrappedValue != nil
                }, set: { value in
                    if !value {
                        item.wrappedValue = nil
                    }
                }
            ),
            title: title,
            subtitle: subtitle,
            buttons: {
                guard let value = item.wrappedValue else {
                    return []
                }
                return buttons(value)
            }(),
            alignment: alignment
        )
    }
}
