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
    
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var sidebarModel: SidebarModel
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                // Only show traffic lights if the sidebar is on the leading side
                if userPreferences.sidebarPosition == .leading {
                    TrafficLights()
                }
                
                SidebarToolbarButton(userPreferences.sidebarPosition == .leading ? "sidebar.left" : "sidebar.right", action: sidebarModel.toggleSidebar)
                    .padding(.leading, userPreferences.sidebarPosition == .trailing ? 5 : 0)
                
                Spacer()
                
                SidebarToolbarButton("arrow.left", disabled: (browserWindowState.currentSpace?.currentTab?.canGoBack ?? false) == false, action: backButtonAction)
                
                SidebarToolbarButton("arrow.right", disabled: (browserWindowState.currentSpace?.currentTab?.canGoForward ?? false) == false, action: forwardButtonAction)
                
                SidebarToolbarButton("arrow.trianglehead.clockwise", disabled: browserWindowState.currentSpace?.currentTab == nil, action: refreshButtonAction)
            }
            .frame(alignment: .top)
            .padding(.top, .approximateTrafficLightsTopPadding)
            .padding(.trailing, .sidebarPadding)
        }
    }
    
    private func backButtonAction() {
        let currentTab = browserWindowState.currentSpace?.currentTab
        if NSEvent.modifierFlags.contains(.command) {
            
        } else {
            currentTab?.webview?.goBack()
        }
    }
    
    private func forwardButtonAction() {
        if NSEvent.modifierFlags.contains(.command) {
        } else {
            browserWindowState.currentSpace?.currentTab?.webview?.goForward()
        }
    }
    
    private func refreshButtonAction() {
        if NSEvent.modifierFlags.contains(.command) {
            
        } else {
            browserWindowState.currentSpace?.currentTab?.webview?.reload()
        }
    }
}

#Preview {
    SidebarToolbar()
}
