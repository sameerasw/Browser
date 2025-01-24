//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

class UserPreferences: ObservableObject {
    enum SidebarPosition: String, CaseIterable {
        case leading
        case trailing
    }
    
    
    @AppStorage("disable_animations") var disableAnimations = false
    
    @AppStorage("sidebar_position") var sidebarPosition = SidebarPosition.leading
    @AppStorage("sidebar_width") var sidebarWidth = 250.0
    @AppStorage("sidebar_trafficLights_opacity") var sidebarTrafficLightsOpacity = 1.0
    
//    let sidebarFraction = FractionHolder.usingUserDefaults(0.20, key: "sidebar_fraction")
//    let sidebarHide = SideHolder.usingUserDefaults(key: "sidebar_hide")
    
    func toggleSidebar() {
//        let animation: Animation = .snappy(duration: 0.2)
        // Hide sidebar
//        if (sidebarHide.side == nil) {
//            withAnimation(animation) {
////                sidebarHide.toggle(.left)
//                setTrafficLights(false)
//                sidebarTrafficLightsOpacity = 1
//            }
//        } else {
//            withAnimation(animation) {
////                sidebarHide.toggle(.left)
//            } completion: {
//                self.setTrafficLights(true)
//                self.sidebarTrafficLightsOpacity = 0
//            }
//        }
    }
    
    func areTrafficLightsHidden() -> Bool {
        guard let keyWindow = NSApp.keyWindow else { return false }
        return keyWindow.standardWindowButton(.closeButton)?.isHidden ?? false
    }
    
    func setTrafficLights(_ show: Bool) {
        guard let keyWindow = NSApp.keyWindow else { return }
        keyWindow.standardWindowButton(.closeButton)?.isHidden = !show
        keyWindow.standardWindowButton(.miniaturizeButton)?.isHidden = !show
        keyWindow.standardWindowButton(.zoomButton)?.isHidden = !show
    }
}
