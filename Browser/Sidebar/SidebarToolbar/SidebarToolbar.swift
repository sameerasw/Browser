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
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    
    @EnvironmentObject var userPreferences: UserPreferences
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    let browserSpaces: [BrowserSpace]
    
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
        guard let currentSpace = browserWindowState.currentSpace,
              let currentTab = browserWindowState.currentSpace?.currentTab,
              let backItem = currentTab.webview?.backForwardList.backItem
        else { return }
        
        if NSEvent.modifierFlags.contains(.command) {
            let newTab = BrowserTab(title: backItem.title ?? "", favicon: nil, url: backItem.url, browserSpace: currentSpace)
            currentSpace.tabs.insert(newTab, at: currentTab.order + 1)
            currentSpace.currentTab = newTab
        } else {
            currentTab.webview?.goBack()
        }
    }
    
    private func forwardButtonAction() {
        guard let currentSpace = browserWindowState.currentSpace,
                let currentTab = browserWindowState.currentSpace?.currentTab,
                let forwardItem = currentTab.webview?.backForwardList.forwardItem
        else { return }
        
        if NSEvent.modifierFlags.contains(.command) {
            let newTab = BrowserTab(title: forwardItem.title ?? "", favicon: nil, url: forwardItem.url, browserSpace: currentSpace)
            currentSpace.tabs.insert(newTab, at: currentTab.order + 1)
            currentSpace.currentTab = newTab
        } else {
            browserWindowState.currentSpace?.currentTab?.webview?.goForward()
        }
    }
    
    private func refreshButtonAction() {
        guard let currentSpace = browserWindowState.currentSpace,
                let currentTab = browserWindowState.currentSpace?.currentTab
        else { return }
        
        if NSEvent.modifierFlags.contains(.command) {
            let newTab = BrowserTab(title: currentTab.title, favicon: currentTab.favicon, url: currentTab.url, browserSpace: currentSpace)
            currentSpace.tabs.insert(newTab, at: currentTab.order + 1)
            currentSpace.currentTab = newTab
        } else {
            browserWindowState.currentSpace?.currentTab?.reload()
        }
    }
}
