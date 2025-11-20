//
//  AquariumCellView.swift
//  Izzirium
//
//  Created by Loris Perret on 13/11/2025.
//

import DesignSystem
import SwiftUI

struct AquariumCellView: View {

    // MARK: - Properties

    @EnvironmentObject private var pathNavigator: ZZPathNavigator
    
    let item: AquariumUI

    // MARK: - Body

    var body: some View {
        ZZCard {
            ZZText("\(item.name)")
        } action: {
            pathNavigator.append(
                AnyZZScreen(AquariumScreen.detail(item))
            )
        }
        .zzShadow(.medium)
    }

    // MARK: - Methods
}

#if DEBUG

#Preview {
    AquariumCellView(
        item: AquariumUI.Fake.preview
    )
}

#endif
