//
//  HistoryEntryRowContextMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/1/25.
//

import SwiftUI

/// Context menu for a history entry row. Contains actions to open the history entry in a new tab, in a new window, or to delete it.

struct HistoryEntryRowContextMenu: ViewModifier {
    
    @Environment(\.modelContext) var modelContext
    
    let entry: BrowserHistoryEntry
    let browserTab: BrowserTab

    func body(content: Content) -> some View {
        content.contextMenu {
            Button("Open") {
                browserTab.title = entry.title
                browserTab.url = entry.url
                browserTab.favicon = entry.favicon
                browserTab.type = .web
            }
            
            Button("Open in New Tab") {
                if let currentSpace = browserTab.browserSpace {
                    let isCurrentTabPinned = currentSpace.pinnedTabs.contains(browserTab)
                    let insertionOrder = isCurrentTabPinned ? currentSpace.tabs.count : browserTab.order + 1
                    currentSpace.openNewTab(BrowserTab(title: entry.title, favicon: entry.favicon, url: entry.url, order: insertionOrder, browserSpace: currentSpace, type: .web), using: modelContext)
                }
            }

            Divider()
            
            Button("Delete Entry") {
                modelContext.delete(entry)
                try? modelContext.save()
            }
        }
    }
}
