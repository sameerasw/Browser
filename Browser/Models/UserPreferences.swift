//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

class UserPreferences: ObservableObject {
    
    enum SidebarPosition: String {
        case leading
        case trailing
    }
    
    @AppStorage("disable_animations") var disableAnimations = false
    
    @AppStorage("sidebar_position") var sidebarPosition = SidebarPosition.leading
    @AppStorage("sidebar_width") var sidebarWidth = 250.0
}
