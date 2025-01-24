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
    
    init(_ systemImage: String, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
        }
        .buttonStyle(SidebarToolbarButtonStyle())
    }
}
