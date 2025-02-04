//
//  SidebarTabContextMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/1/25.
//

import SwiftUI

/// Context menu for a tab in the sidebar
struct SidebarTabContextMenu: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    @Bindable var browserTab: BrowserTab
    
    var body: some View {
        Group {
            Button("Print") {
                print("Print")
            }
            
            Divider()
            
            Button("Close Tab", action: closeTab)
            Button("Close Tabs Below", action: closeTabsBelow)
            Button("Close Tabs Above", action: closeTabsAbove)
        }
    }
    
    /// Close (delete) the tab and selects the next tab
    func closeTab() {
        guard let currentSpace = browserWindowState.currentSpace,
                let index = currentSpace.tabs.firstIndex(where: { $0.id == browserTab.id })
        else { return }
        let newTab = currentSpace.tabs[safe: index == 0 ? 1 : index - 1]
        
        browserTab.stopObserving()
        currentSpace.unloadTab(browserTab)
        modelContext.delete(browserTab)
        try? modelContext.save()
        
        withAnimation(.bouncy) {
            if let newTab {
                currentSpace.currentTab = newTab
            }
        }
    }
    
    /// Close (delete) the tabs below the current tab
    func closeTabsBelow() {
        guard let currentSpace = browserWindowState.currentSpace,
                let index = currentSpace.tabs.firstIndex(where: { $0.id == browserTab.id })
        else { return }
        
        withAnimation(.bouncy) {
            for tab in currentSpace.tabs.suffix(from: index + 1) {
                tab.stopObserving()
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
        
        withAnimation(.bouncy) {
            for tab in currentSpace.tabs.prefix(upTo: index) {
                tab.stopObserving()
                currentSpace.unloadTab(tab)
                modelContext.delete(tab)
            }
            try? modelContext.save()
        }
    }
}
