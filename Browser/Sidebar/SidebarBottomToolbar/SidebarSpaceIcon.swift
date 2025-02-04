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
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    let browserSpaces: [BrowserSpace]
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        Button(browserSpace.name, systemImage: browserSpace.systemImage, action: setBrowserSpace)
        .buttonStyle(.sidebarHover())
        .foregroundStyle(browserWindowState.currentSpace == browserSpace ? .gray : .gray.opacity(0.3))
        .sidebarSpaceContextMenu(browserSpaces: browserSpaces, browserSpace: browserSpace)
    }
    
    /// Set the current space to the selected space and scroll to the selected space
    func setBrowserSpace() {
        withAnimation(.bouncy) {
            browserWindowState.currentSpace = browserSpace
            browserWindowState.viewScrollState = browserSpace.id
            browserWindowState.tabBarScrollState = browserSpace.id
        }
    }
}
