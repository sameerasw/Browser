//
//  SidebarToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// Toolbar with buttons (traffic lights, web navigation) for the sidebar
struct SidebarToolbar: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(SidebarModel.self) var sidebarModel
    
    @EnvironmentObject var userPreferences: UserPreferences
    @Environment(BrowserWindowState.self) var browserWindowState
    
    let browserSpaces: [BrowserSpace]
    
    var currentTab: BrowserTab? {
        browserWindowState.currentSpace?.currentTab
    }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
//                SidebarToolbarButton(userPreferences.sidebarPosition == .leading ? "sidebar.left" : "sidebar.right", action: sidebarModel.toggleSidebar)
//                    .padding(.leading, userPreferences.sidebarPosition == .trailing ? 5 : 0)
//                // Only add padding if the sidebar is on the leading side
//                    .padding(.leading, userPreferences.sidebarPosition == .leading ? 85 : 0)
                Button(action: { userPreferences.webContentTransparency.toggle() }) {
                    Image(systemName: userPreferences.webContentTransparency ? "app.background.dotted" : "app.translucent")
                }
                .buttonStyle(.sidebarHover(enabledColor: .primary, disabled: false, disabledColor: .primary))

                Spacer()
                
                if userPreferences.urlBarPosition == .onSidebar {
                    SidebarToolbarButton("arrow.left", disabled: currentTab == nil || currentTab?.canGoBack == false, action: browserWindowState.backButtonAction)
                    
                    SidebarToolbarButton("arrow.right", disabled: currentTab == nil || currentTab?.canGoForward == false, action: browserWindowState.forwardButtonAction)
                    
                    SidebarToolbarButton("arrow.trianglehead.clockwise", disabled: currentTab == nil, action: browserWindowState.refreshButtonAction)

                }
            }
            .padding(.top, .approximateTrafficLightsTopPadding)
            .padding(.trailing, .sidebarPadding)
        }
        .frame(height: 38)
        .background {
            Rectangle()
                .fill(.black.opacity(0.0001))
        }
    }
}
