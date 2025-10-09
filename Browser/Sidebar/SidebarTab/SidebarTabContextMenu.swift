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
            
            if browserTab.browserSpace?.pinnedTabs.contains(browserTab) == false {
                Button("Pin Tab", action: pinTab)
            } else {
                Button("Unpin Tab", action: unpinTab)
            }
            
            Button("Duplicate Tab", action: duplicateTab)
            
            if browserTab.browserSpace?.pinnedTabs.contains(browserTab) == false {
                Button("Suspend Tab", action: suspendTab)
            }
            
            Divider()
            
            if let browserSpace = browserTab.browserSpace, browserSpace.pinnedTabs.contains(browserTab) {
                Button(browserTab.isSuspended ? "Close Tab" : "Suspend Tab", action: closeTab)
            } else {
                Button("Close Tab", action: closeTab)
            }
            
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
    
    /// Pin the tab
    func pinTab() {
        withAnimation(.browserDefault) {
            browserTab.browserSpace?.pinTab(browserTab, using: modelContext)
        }
    }
    
    /// Unpin the tab
    func unpinTab() {
        withAnimation(.browserDefault) {
            browserWindowState.currentSpace?.unpinTab(browserTab, using: modelContext)
        }
    }
    
    /// Duplicate the tab and selects the new tab
    func duplicateTab() {
        let duplicateTab = BrowserTab(title: browserTab.title, favicon: browserTab.favicon, url: browserTab.url, order: browserTab.order + 1, browserSpace: browserTab.browserSpace)
        if browserTab.browserSpace?.pinnedTabs.contains(browserTab) == false {
            browserWindowState.currentSpace?.tabs.insert(duplicateTab, at: browserTab.order + 1)
            browserWindowState.currentSpace?.currentTab = duplicateTab
        } else {
            browserWindowState.currentSpace?.pinnedTabs.insert(duplicateTab, at: browserTab.order + 1)
            browserWindowState.currentSpace?.currentTab = duplicateTab
        }
    }
    
    /// Suspend the tab
    func suspendTab() {
        // If this is the current tab, switch to another tab first
        if browserWindowState.currentSpace?.currentTab == browserTab {
            let space = browserWindowState.currentSpace
            // Find another tab that's not suspended
            let newTab = space?.allTabs.first(where: { $0 != browserTab && !$0.isSuspended })
            browserWindowState.currentSpace?.currentTab = newTab
        }
        
        browserTab.isSuspended = true
        browserTab.browserSpace?.unloadTab(browserTab)
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
