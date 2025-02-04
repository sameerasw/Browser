//
//  SidebarModel.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// Model for the sidebar
class SidebarModel: ObservableObject {
    
    @Published var currentSidebarWidth: CGFloat = 220
    @Published var lastSidebarWidth: CGFloat = 220
    @Published var sidebarCollapsed: Bool = false {
        // Start or stop the mouse monitor when the sidebar is collapsed
        didSet {
            if sidebarCollapsed {
                startMouseMonitor()
            } else {
                stopMouseMonitor()
            }
        }
    }
    
    /// Monitor for mouse movement
    private var mouseMonitor: Any?
    
    /// Toggle the sidebar
    func toggleSidebar() {
        // Only animate if the hover sidebar is not shown
        withAnimation(sidebarCollapsed && currentSidebarWidth != 0 ? nil : .smooth(duration: 0.2)) {
            sidebarCollapsed.toggle()
            if sidebarCollapsed {
                lastSidebarWidth = currentSidebarWidth
                currentSidebarWidth = 0
                setTrafficLights(show: false)
            } else {
                self.currentSidebarWidth = self.lastSidebarWidth
            }
        } completion: {
            // When finished, show the traffic lights if the sidebar is not collapsed
            if !self.sidebarCollapsed {
                self.setTrafficLights(show: true)
            }
        }
    }
    
    /// Set the visibility of the native window traffic lights
    /// - Parameter show: Whether to show the traffic lights
    func setTrafficLights(show: Bool) {
        guard let keyWindow = NSApp.keyWindow else { return }
        keyWindow.standardWindowButton(.closeButton)?.isHidden = !show
        keyWindow.standardWindowButton(.miniaturizeButton)?.isHidden = !show
        keyWindow.standardWindowButton(.zoomButton)?.isHidden = !show
    }
    
    /// Start the mouse monitor
    func startMouseMonitor() {
        mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: .mouseMoved, handler: handleMouseMovement)
    }
    
    /// Handle the mouse movement
    /// Only show the sidebar when the cursor is near the window's edge + threshold
    /// - Parameter event: The mouse movement event
    func handleMouseMovement(event: NSEvent) -> NSEvent? {
        guard let keyWindow = NSApp.keyWindow,
              let sidebarPosition = UserDefaults.standard.string(forKey: "sidebar_position")
        else { return event }
        
        let windowX = sidebarPosition == "leading" ? keyWindow.frame.minX : keyWindow.frame.maxX
        let cursorX = NSEvent.mouseLocation.x - windowX
        
        // Inside window threshold
        let threshold = currentSidebarWidth != 0 ? currentSidebarWidth + 25 : 50
        let inRange = sidebarPosition == "leading" ?
                            cursorX >= -50 && cursorX <= threshold :
                            cursorX <= 50 && cursorX >= -threshold
        
        withAnimation(.smooth(duration: 0.2)) {
            if inRange {
                currentSidebarWidth = lastSidebarWidth
                if sidebarPosition == "leading" {
                    setTrafficLights(show: true)
                }
            } else {
                if sidebarPosition == "leading" {
                    setTrafficLights(show: false)
                }
                currentSidebarWidth = 0
            }
        }
        
        return event
    }
    
    /// Stop the mouse monitor
    func stopMouseMonitor() {
        NSEvent.removeMonitor(mouseMonitor as Any)
    }
}
