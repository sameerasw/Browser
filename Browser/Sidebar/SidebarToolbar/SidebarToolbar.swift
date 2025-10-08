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
    
    /// Check if styles are enabled for the current website
    var areStylesEnabledForCurrentSite: Bool {
        guard let url = currentTab?.url else { return false }
        return StyleManager.shared.areStylesEnabled(for: url)
    }
    
    var body: some View {
            HStack {
                Button(action: { 
                    if let url = currentTab?.url {
                        StyleManager.shared.toggleStyles(for: url)
                        // Reapply styles to current tab
                        if let viewController = currentTab?.viewController {
                            viewController.applyTransparency()
                        }
                    }
                }) {
                    Image(systemName: areStylesEnabledForCurrentSite ? "app.background.dotted" : "app.translucent")
                }
                .buttonStyle(.sidebarHover(enabledColor: .primary, disabled: currentTab == nil, disabledColor: .primary))
            }
        }
}
