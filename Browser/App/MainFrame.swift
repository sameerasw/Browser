//
//  MainFrame.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI
import SwiftData

/// Main frame of the browser.
struct MainFrame: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    @StateObject var sidebarModel = SidebarModel()
    
    @Query(sort: \BrowserSpace.order) var browserSpaces: [BrowserSpace]
    
    var body: some View {
        HStack(spacing: 0) {
            if userPreferences.sidebarPosition == .leading {
                if !sidebarModel.sidebarCollapsed {
                    sidebar
                    SidebarResizer()
                }
            }
            
            PageWebView(browserSpaces: browserSpaces)
                .id("PageWebView")
                .frame(maxWidth: .infinity)
                .conditionalModifier(condition: userPreferences.roundedCorners) { $0.clipShape(RoundedRectangle(cornerRadius: 8)) }
                .conditionalModifier(condition: userPreferences.enableShadow) { $0.shadow(radius: 3) }
                .conditionalModifier(condition: userPreferences.enablePadding) {
                    $0
                        .padding([.top, .bottom], 10)
                        .padding(userPreferences.sidebarPosition == .leading ? .leading : .trailing, sidebarModel.sidebarCollapsed ? 10 : 5)
                        .padding([userPreferences.sidebarPosition == .leading ? .trailing : .leading], 10)
                }
            
            if userPreferences.sidebarPosition == .trailing {
                if !sidebarModel.sidebarCollapsed {
                    SidebarResizer()
                    sidebar
                }
            }
        }
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
        .transaction {
            if userPreferences.disableAnimations {
                $0.animation = nil
            }
        }
        .environmentObject(sidebarModel)
    }
    
    var sidebar: some View {
        Sidebar(browserSpaces: browserSpaces)
            .frame(width: sidebarModel.currentSidebarWidth)
            .readingWidth(width: $sidebarModel.currentSidebarWidth)
    }
}
