//
//  EditCommands.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/11/25.
//

import SwiftUI
import KeyboardShortcuts

struct EditCommands: Commands {
    
    @Environment(\.undoManager) var undoManager
    
    @FocusedValue(\.browserActiveWindowState) var browserWindowState
    
    @State var isEditable = false
    
    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            
        }
        
        CommandGroup(after: .undoRedo) {
            Button("Copy Current URL", action: browserWindowState?.copyURLToClipboard)
                .globalKeyboardShortcut(.copyCurrentURL)
            
            Divider()
            
            if let webView = browserWindowState?.currentSpace?.currentTab?.webview {
                Button(isEditable ? "Stop Editing Text On Page" : "Edit Text On Page") {
                    isEditable.toggle()
                    webView.toggleEditable()
                }
                .globalKeyboardShortcut(.toggleEditing)
            }
        }
    }
}

extension KeyboardShortcuts.Name {
    static let copyCurrentURL = Self("copyCurrentURL", default: .init(.c, modifiers: [.command, .shift]))
    
    static let toggleEditing = Self("toggleEditing")
}
