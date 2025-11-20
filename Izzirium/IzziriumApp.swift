//
//  IzziriumApp.swift
//  Izzirium
//
//  Created by Loris Perret on 06/11/2025.
//

import DesignSystem
//import KastorBoard
import SKToast
import SwiftUI
import SwiftData

@main
struct IzziriumApp: App {

    var body: some Scene {
        WindowGroup {
            SKToastWindowContainer {
//                KastorWindowContainer(
//                    isKastorEnabled: KastorConstants.isKastorEnabled,
//                    theme: KastorBoardTheme(
//                        primary: Color.primaryMedium,
//                        surface: Color.lightHightest,
//                        surfaceLow: Color.neutralLower,
//                        onSurface: Color.darkHightest,
//                        onSurfaceVariantLow: Color.neutralMedium,
//                        onSurfaceVariantHigh: Color.neutralLow
//                    ),
//                    defaultBoard: .logs
//                ) {
                    RootCoordinatorView(viewModel: RootCoordinatorViewModel())
//                }
            }
        }
    }
}
