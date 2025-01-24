//
//  SidebarModel.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

class SidebarModel: ObservableObject {
    
    @Published var currentSidebarWidth: CGFloat = 250
    @Published var lastSidebarWidth: CGFloat = 250
    @Published var sidebarCollapsed: Bool = false
    
    func toggleSidebar() {
        withAnimation(.easeInOut(duration: 0.2)) {
            sidebarCollapsed.toggle()
            if sidebarCollapsed {
                lastSidebarWidth = currentSidebarWidth
                currentSidebarWidth = 0
                setTrafficLights(show: false)
            } else {
                currentSidebarWidth = lastSidebarWidth
                setTrafficLights(show: true)
            }
        }
    }
    
    func setTrafficLights(show: Bool) {
        guard let keyWindow = NSApp.keyWindow else { return }
        keyWindow.standardWindowButton(.closeButton)?.isHidden = !show
        keyWindow.standardWindowButton(.miniaturizeButton)?.isHidden = !show
        keyWindow.standardWindowButton(.zoomButton)?.isHidden = !show
    }
}
