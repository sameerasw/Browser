//
//  ViewCommands.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/9/25.
//

import SwiftUI
import KeyboardShortcuts

struct ViewCommands: Commands {
    
    @FocusedValue(\.browserActiveWindowState) var browserWindowState
    @FocusedValue(\.sidebarModel) var sidebarModel
    
    var body: some Commands {
        CommandGroup(replacing: .toolbar) {
            Button("Toggle Sidebar", action: sidebarModel?.toggleSidebar)
                .globalKeyboardShortcut(.toggleSidebar)
            
            Divider()
            
            Button("Zoom Actual Size", action: browserWindowState?.currentSpace?.currentTab?.webview?.zoomActualSize)
                .globalKeyboardShortcut(.zoomActualSize)
            Button("Zoom In", action: browserWindowState?.currentSpace?.currentTab?.webview?.zoomIn)
                .keyboardShortcut("+", modifiers: .command)
            Button("Zoom Out", action: browserWindowState?.currentSpace?.currentTab?.webview?.zoomOut)
                .globalKeyboardShortcut(.zoomOut)
            
            Divider()
        }
    }
}

extension KeyboardShortcuts.Name {
    static let toggleSidebar = Self("toggle_sidebar", default: .init(.s, modifiers: .command))
    
    static let zoomActualSize = Self("zoom_actual_size", default: .init(.zero, modifiers: .command))
    static let zoomIn = Self("zoom_in", default: .init(.equal, modifiers: .command))
    static let zoomOut = Self("zoom_out", default: .init(.minus, modifiers: .command))
    
    static let openDeveloperTools = Self("open_developer_tools", default: .init(.i, modifiers: [.option, .command]))
}
