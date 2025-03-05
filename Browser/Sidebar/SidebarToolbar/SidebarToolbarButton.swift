//
//  SidebarToolbarButton.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// A button that is used in the sidebar toolbar
struct SidebarToolbarButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(BrowserWindowState.self) var browserWindowState
    
    let systemImage: String
    let action: () -> Void
    let disabled: Bool
    
    init(_ systemImage: String, disabled: Bool = false, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.action = action
        self.disabled = disabled
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
        }
        .buttonStyle(.sidebarHover(enabledColor: browserWindowState.currentSpace?.textColor(in: colorScheme) ?? .primary, disabled: disabled))
    }
}
