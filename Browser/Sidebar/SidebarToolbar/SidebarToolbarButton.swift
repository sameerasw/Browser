//
//  SidebarToolbarButton.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// A button that is used in the sidebar toolbar
struct SidebarToolbarButton: View {
    
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
        .buttonStyle(.sidebarHover(disabled: disabled))
    }
}
