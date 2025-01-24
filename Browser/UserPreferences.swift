//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SplitView

class UserPreferences: ObservableObject {
    enum SidebarPosition: String, CaseIterable {
        case leading
        case trailing
    }
    
    
    @AppStorage("disable_animations") var disableAnimations = false
    
    @AppStorage("sidebar_position") var sidebarPosition = SidebarPosition.leading
    @AppStorage("sidebar_width") var sidebarWidth = 250.0
    @Published var showSidebar = true
    
    let sidebarFraction = FractionHolder.usingUserDefaults(0.20, key: "sidebar_fraction")
    let sidebarHide = SideHolder.usingUserDefaults(key: "sidebar_hide")
    
    func toggleSidebar() {
        withAnimation {
            sidebarHide.toggle(.left)
        }
    }
}
