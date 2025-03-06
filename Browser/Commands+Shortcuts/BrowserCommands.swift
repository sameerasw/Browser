//
//  BrowserCommands.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/7/25.
//

import SwiftUI

struct BrowserCommands: Commands {
    
    @FocusedValue(\.browserActiveWindowState) var browserActiveWindowState
    
    var body: some Commands {
        
        CommandGroup(after: .appInfo) {
            Button("Acknowledgements") {
                browserActiveWindowState?.showAcknowledgements.toggle()
            }
        }
        
        FileCommands()
        EditCommands()
        ViewCommands()
        HistoryCommands()
    }
}
