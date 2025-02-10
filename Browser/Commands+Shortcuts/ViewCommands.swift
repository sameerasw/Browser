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
    
    var body: some Commands {
        CommandGroup(replacing: .toolbar) {
            Button("Zoom Actual Size", action: browserWindowState?.currentSpace?.currentTab?.webview?.zoomActualSize)
                .globalKeyboardShortcut(.zoomActualSize)
            Button("Zoom In", action: browserWindowState?.currentSpace?.currentTab?.webview?.zoomIn)
                .keyboardShortcut("+", modifiers: .command)
            Button("Zoom Out", action: browserWindowState?.currentSpace?.currentTab?.webview?.zoomOut)
                .globalKeyboardShortcut(.zoomOut)
        }
    }
}

extension KeyboardShortcuts.Name {
    static let zoomActualSize = Self("zoom_actual_size", default: .init(.zero, modifiers: .command))
    static let zoomIn = Self("zoom_in", default: .init(.equal, modifiers: .command))
    static let zoomOut = Self("zoom_out", default: .init(.minus, modifiers: .command))
}
