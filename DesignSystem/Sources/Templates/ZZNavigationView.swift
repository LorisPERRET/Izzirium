//
//  ZZNavigationView.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 02/07/2025.
//

import SwiftUI

/**

A navigation view that displays a root view and enables you to present additional views over the root view.

Use an ZZNavigationView to present a stack of views over a root view. People can add views to the top of the stack by clicking or tapping a NavigationLink, and remove views using built-in, platform-appropriate controls, like a Back button or a swipe gesture. The stack always displays the most recently added view that hasn’t been removed, and doesn’t allow the root view to be removed.

 ### Usage

 ```
 struct Sample: View {

     // MARK: Properties

     @State private var path = [AnyZZScreen]()

     // MARK: View

     var body: some View {
         ZZNavigationView(path: $path) {
             VStack {
                 ZZText("Some view")
             }
             .navigationTitle("title")
         }
     }
 }
 ``
 */
public struct ZZNavigationView<Content: View>: View {

    // MARK: Properties

    private let path: Binding<[AnyZZScreen]>
    private let content: Content

    private var toolbarVisibility: Visibility {
        path.isEmpty ? .visible : .hidden
    }

    // MARK: View

    public var body: some View {
        NavigationStack(path: path) {
            content
                .toolbar(toolbarVisibility, for: .tabBar)
        }
        .environmentObject(ZZPathNavigator(path))
    }

    // MARK: Init

    /// A navigation view that displays a root view and enables you to present additional views over the root view.
    ///
    /// - Parameters:
    ///   - path: stack of views
    ///   - content: view content
    ///   - onDismissAction: action to substitute to the one to perform when the navigation view is presented and the view is dismissed
    public init(
        path: Binding<[AnyZZScreen]>,
        @ViewBuilder content: () -> Content
    ) {
        self.path = path
        self.content = content()
    }
}
