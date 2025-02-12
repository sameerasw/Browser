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
    
    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            
        }
        
        CommandGroup(after: .undoRedo) {
            Button("Copy Current URL", action: browserWindowState?.copyURLToClipboard)
                .globalKeyboardShortcut(.copyCurrentURL)
        }
    }
}

extension KeyboardShortcuts.Name {
    static let copyCurrentURL = Self("copyCurrentURL", default: .init(.c, modifiers: [.command, .shift]))
}
