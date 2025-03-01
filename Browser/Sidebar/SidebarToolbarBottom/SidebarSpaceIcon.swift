//
//  SidebarSpaceIcon.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

/// Icon for a browser space in the sidebar space list
struct SidebarSpaceIcon: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    let browserSpaces: [BrowserSpace]
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        Button(browserSpace.name, systemImage: browserSpace.systemImage) { browserWindowState.goToSpace(browserSpace) }
            .buttonStyle(.sidebarHover(hoverColor: browserSpace.getColors.first ?? .primary))
            .opacity(browserWindowState.currentSpace == browserSpace ? 0.7 : 0.3)
            .sidebarSpaceContextMenu(browserSpaces: browserSpaces, browserSpace: browserSpace)
    }
}
