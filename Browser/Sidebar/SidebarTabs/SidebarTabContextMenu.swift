//
//  SidebarTabContextMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/1/25.
//

import SwiftUI
import SwiftData

/// Context menu for a tab in the sidebar
struct SidebarTabContextMenu: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(BrowserWindowState.self) var browserWindowState
    
    @Bindable var browserTab: BrowserTab
        
    var body: some View {
        Group {
            Button("Copy Link", action: browserTab.copyLink)
            Button("Reload Tab", action: browserTab.reload)
            
            Divider()
            
            ShareLink("Share...", item: browserTab.url)
            
            Divider()
            
            Button("Duplicate Tab", action: duplicateTab)
            
            Divider()
            
            Button("Close Tab", action: closeTab)
            
            if let tabCount = browserWindowState.currentSpace?.tabs.count, tabCount > 1 {
                if browserTab.order < tabCount - 1 {
                    Button("Close Tabs Below", action: closeTabsBelow)
                }
                
                if browserTab.order > 0 {
                    Button("Close Tabs Above", action: closeTabsAbove)
                }
            }
        }
    }
    
    /// Duplicate the tab and selects the new tab
    func duplicateTab() {
        let duplicateTab = BrowserTab(title: browserTab.title, favicon: browserTab.favicon, url: browserTab.url, order: browserTab.order + 1, browserSpace: browserTab.browserSpace)
        browserWindowState.currentSpace?.tabs.insert(duplicateTab, at: browserTab.order + 1)
        browserWindowState.currentSpace?.currentTab = duplicateTab
    }
    
    /// Close (delete) the tab and selects the next tab
    func closeTab() {
        browserWindowState.currentSpace?.closeTab(browserTab, using: modelContext)
    }
    
    /// Close (delete) the tabs below the current tab
    func closeTabsBelow() {
        guard let currentSpace = browserWindowState.currentSpace,
                let index = currentSpace.tabs.firstIndex(where: { $0.id == browserTab.id })
        else { return }
        
        withAnimation(.browserDefault) {
            for tab in currentSpace.tabs.suffix(from: index + 1) {
                currentSpace.unloadTab(tab)
                modelContext.delete(tab)
            }
            try? modelContext.save()
        }
    }
    
    /// Close (delete) the tabs above the current tab
    func closeTabsAbove() {
        guard let currentSpace = browserWindowState.currentSpace,
                let index = currentSpace.tabs.firstIndex(where: { $0.id == browserTab.id })
        else { return }
        
        withAnimation(.browserDefault) {
            for tab in currentSpace.tabs.prefix(upTo: index) {
                currentSpace.unloadTab(tab)
                modelContext.delete(tab)
            }
            try? modelContext.save()
        }
    }
}
