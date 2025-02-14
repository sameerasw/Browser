//
//  SidebarBottomAddMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/4/25.
//

import SwiftUI
import SwiftData

/// A menu that opens from the bottom of the sidebar to create new spaces or tabs
struct SidebarBottomAddMenu: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    @EnvironmentObject var userPreferences: UserPreferences
    
    let createSpace: () -> Void
    let disableNewTabButton: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Button("New Space", systemImage: "plus.square.on.square") {
                sidebarModel.dismissBottomNewMenu()
                createSpace()
            }
            
            Divider()
            
            Button("New Tab", systemImage: "plus.app") {
                sidebarModel.dismissBottomNewMenu()
                browserWindowState.searchOpenLocation = .fromNewTab
            }
            .buttonStyle(.sidebarHover(font: .title3, padding: 4, fixedWidth: nil, disabled: disableNewTabButton, showLabel: true, cornerRadius: 6))
        }
        .buttonStyle(.sidebarHover(font: .title3, padding: 4, fixedWidth: nil, showLabel: true, cornerRadius: 6))
        .padding(5)
        .background()
        .macOSWindowBorderOverlay()
        .transition(.scale.animation(userPreferences.disableAnimations ? nil : .bouncy(duration: 0.2)))
        .padding(.bottom, 45)
        .padding(.horizontal, .sidebarPadding)
    }
}
