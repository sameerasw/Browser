//
//  SidebarToolbarButton.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

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
