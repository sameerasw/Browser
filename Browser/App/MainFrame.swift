//
//  MainFrame.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// Main frame of the browser.
struct MainFrame: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    @StateObject var sidebarModel = SidebarModel()
    
    var body: some View {
        HStack(spacing: 0) {
            if userPreferences.sidebarPosition == .leading {
                if !sidebarModel.sidebarCollapsed {
                    sidebar
                    SidebarResizer()
                }
            }
            
            WebView()
                .clipShape(.rect(cornerRadius: 8))
                .frame(maxWidth: .infinity)
                .shadow(radius: 3)
                .padding([.top, .bottom], 10)
                .padding(userPreferences.sidebarPosition == .leading ? .leading : .trailing, sidebarModel.sidebarCollapsed ? 10 : 5)
                .padding([userPreferences.sidebarPosition == .leading ? .trailing : .leading], 10)
            
            if userPreferences.sidebarPosition == .trailing {
                if !sidebarModel.sidebarCollapsed {
                    SidebarResizer()
                    sidebar
                }
            }
        }
        .animation(userPreferences.disableAnimations ? nil : .bouncy, value: userPreferences.sidebarPosition)
        .frame(maxWidth: .infinity)
        .toolbar { Text("") }
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        .background {
            if let color = browserWindowState.currentSpace?.colors.first {
                Color(hex: color)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .overlay {
            if browserWindowState.searchOpenLocation != .none {
                SearchView()
            }
        }
        // Show the sidebar by hovering the mouse on the edge of the screen
        .overlay(alignment: userPreferences.sidebarPosition == .leading ? .topLeading : .topTrailing) {
            if sidebarModel.sidebarCollapsed && sidebarModel.currentSidebarWidth > 0 {
                sidebar
                    .padding(userPreferences.sidebarPosition == .leading ? .trailing : .leading, .sidebarPadding)
                    .background(.ultraThinMaterial)
                    .background {
                        if let color = browserWindowState.currentSpace?.colors.first {
                            Color(hex: color)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .transition(.move(edge: userPreferences.sidebarPosition == .leading ? .leading : .trailing))
            }
        }
        .environmentObject(sidebarModel)
    }
    
    var sidebar: some View {
        Sidebar()
            .frame(width: sidebarModel.currentSidebarWidth)
            .readingWidth(width: $sidebarModel.currentSidebarWidth)
    }
}
