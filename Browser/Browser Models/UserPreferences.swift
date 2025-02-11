//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

/// User preferences that are stored in AppStorage
class UserPreferences: ObservableObject {
    
    enum SidebarPosition: String {
        case leading
        case trailing
    }
    
    @AppStorage("disable_animations") var disableAnimations = false
    @AppStorage("sidebar_position") var sidebarPosition = SidebarPosition.leading {
        didSet {
            changeTrafficLightsTrailingAppearance()
        }
    }
    @AppStorage("show_window_controls_trailing_sidebar") var showWindowControlsOnTrailingSidebar = true {
        didSet {
            changeTrafficLightsTrailingAppearance()
        }
    }
    
    // Web appearance preferences
    @AppStorage("rounded_corners") var roundedCorners = true
    @AppStorage("enable_padding") var enablePadding = true
    @AppStorage("enable_shadow") var enableShadow = true
    
    @AppStorage("clear_selected_tab") var clearSelectedTab = false
    
    func changeTrafficLightsTrailingAppearance() {
        if sidebarPosition == .trailing {
            NSApp.setBrowserWindowControls(hidden: !showWindowControlsOnTrailingSidebar)
        }
    }
}
