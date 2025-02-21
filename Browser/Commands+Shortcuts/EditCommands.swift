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
                    browserWindowState?.presentActionAlert(message: isEditable ? "You Can Now Edit The Text On The Page" : "You Are No Longer Editing The Text On The Page", systemImage: isEditable ? "pencil.and.outline" : "pencil.slash")
                }
                .globalKeyboardShortcut(.toggleEditing)
            }
        }
    }
}

extension KeyboardShortcuts.Name {
    static let copyCurrentURL = Self("copy_current_url", default: .init(.c, modifiers: [.command, .shift]))
    
    static let toggleEditing = Self("toggle_editing")
}
