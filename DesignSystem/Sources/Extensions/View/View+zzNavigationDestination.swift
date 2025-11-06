//
//  View +zzNavigationDestination.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

// swiftlint:disable private_over_fileprivate strict_fileprivate

fileprivate struct ZZNavigationDestinationForPathTypeModifier<D: Hashable, C: View>: ViewModifier {

    // MARK: Properties

    @EnvironmentObject private var pathNavigator: ZZPathNavigator

    let pathElementType: D.Type
    let destination: (D) -> C

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content
            .navigationDestination(
                for: pathElementType,
                destination: destination
            )
    }
}

fileprivate struct ZZNavigationDestinationWithIsPresentedModifier<V: View>: ViewModifier {

    // MARK: Properties

    @EnvironmentObject private var pathNavigator: ZZPathNavigator

    @Binding var isPresented: Bool
    let destination: () -> V

    // MARK: ViewModifier

    func body(content: Content) -> some View {
        content
            .navigationDestination(
                isPresented: $isPresented,
                destination: destination
            )
    }
}

extension View {

    public func zzNavigationDestination<D: Hashable, C: View>(
        for pathElementType: D.Type,
        @ViewBuilder destination builder: @escaping (D) -> C
    ) -> some View {
        modifier(
            ZZNavigationDestinationForPathTypeModifier(
                pathElementType: pathElementType,
                destination: builder
            )
        )
    }

    public func zzNavigationDestination<V>(
        isPresented: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> V
    ) -> some View where V: View {
        modifier(
            ZZNavigationDestinationWithIsPresentedModifier(
                isPresented: isPresented,
                destination: destination
            )
        )
    }
}
