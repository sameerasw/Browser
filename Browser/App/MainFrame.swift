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
    
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userPreferences: UserPreferences
        
    @State var sidebarModel = SidebarModel()
    
    @Query(sort: \BrowserSpace.order) var browserSpaces: [BrowserSpace]
    
    var body: some View {
        HStack(spacing: 0) {
            if userPreferences.sidebarPosition == .leading {
                if !sidebarModel.sidebarCollapsed {
                    sidebar
                    SidebarResizer()
                }
            }
            
            PageWebView(browserSpaces: browserSpaces, browserWindowState: browserWindowState)
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
                .actionAlert()
            
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
            if let currentSpace = browserWindowState.currentSpace {
                SidebarSpaceBackground(browserSpace: currentSpace, isSidebarCollapsed: false)
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
                    .background {
                        if let currentSpace = browserWindowState.currentSpace {
                            SidebarSpaceBackground(browserSpace: currentSpace, isSidebarCollapsed: true)
                        }
                    }
                    .background(.ultraThinMaterial)
                    .padding(userPreferences.sidebarPosition == .leading ? .trailing : .leading, .sidebarPadding)
                    .transition(.move(edge: userPreferences.sidebarPosition == .leading ? .leading : .trailing))
            }
        }
        .transaction {
            if userPreferences.disableAnimations {
                $0.animation = nil
            }
        }
        .environment(sidebarModel)
        .focusedSceneValue(\.sidebarModel, sidebarModel)
        .foregroundStyle(browserWindowState.currentSpace?.textColor(in: colorScheme) ?? .primary)
    }
    
    var sidebar: some View {
        Sidebar(browserSpaces: browserSpaces)
            .frame(width: sidebarModel.currentSidebarWidth)
            .readingWidth(width: $sidebarModel.currentSidebarWidth)
    }
}
