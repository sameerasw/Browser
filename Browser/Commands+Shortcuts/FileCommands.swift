//
//  FileCommands.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/7/25.
//

import SwiftUI

struct FileCommands: Commands {
    
    @FocusedValue(\.browserActiveWindowState) var browserWindowState
    
    var body: some Commands {
        CommandGroup(before: .newItem) {
            Button("New Tab") {
                print(browserWindowState?.currentSpace?.name as Any)
            }
        }
    }
}
