//
//  ToolbarContent+.swift
//  DesignSystem
//
//  Created by JC Neboit on 10/10/2025.
//

import SwiftUI

struct ZZToolbarItemStyle<Content: ToolbarContent>: ToolbarContent {

    // MARK: Properties

    let content: Content

    // MARK: ToolbarContent

    var body: some ToolbarContent {
//        if #available(iOS 26.0, *) {
//            content.sharedBackgroundVisibility(.hidden)
//        } else {
            content
//        }
    }
}

extension ToolbarContent {

    public func zzToolbarItemStyle() -> some ToolbarContent {
        ZZToolbarItemStyle(content: self)
    }
}
