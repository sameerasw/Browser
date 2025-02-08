//
//  BrowserAppDelegate.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import AppKit

/// The app delegate is responsible for handling window events and saving the window position and size
class BrowserAppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var window: NSWindow!
    var windowWasClosed = false
    
    var userPreferences = UserPreferences()
    
    /// Add window observers to save the window position and size
    func applicationWillFinishLaunching(_ notification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeKey(_:)), name: NSWindow.didBecomeKeyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(_:)), name: NSWindow.willCloseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResizeOrMove(_:)), name: NSWindow.didMoveNotification, object: window)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResizeOrMove(_:)), name: NSWindow.didResizeNotification, object: window)
    }
    
    /// Restore the window position and size when the window becomes key
    @objc func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              let windowId = window.identifier?.rawValue,
              windowId.hasPrefix("BrowserWindow")
        else { return }
        
        if windowWasClosed {
            let windowOriginX = UserDefaults.standard.double(forKey: "windowOriginX")
            let windowOriginY = UserDefaults.standard.double(forKey: "windowOriginY")
            let windowWidth = UserDefaults.standard.double(forKey: "windowWidth")
            let windowHeight = UserDefaults.standard.double(forKey: "windowHeight")
            
            var frame = window.frame
            frame.origin.x = windowOriginX
            frame.origin.y = windowOriginY
            frame.size.width = windowWidth
            frame.size.height = windowHeight
            window.setFrame(frame, display: true)
            
            windowWasClosed = false
        }
        
        window.backgroundColor = .clear
        
        if userPreferences.sidebarPosition == .trailing {
            NSApp.setBrowserWindowControls(hidden: !userPreferences.showWindowControlsOnTrailingSidebar)
        }
    }
    
    @objc func windowDidResizeOrMove(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              let windowId = window.identifier?.rawValue,
              windowId.hasPrefix("BrowserWindow")
        else { return }
        
        saveWindowPositionAndSize(window)
    }
    
    @objc func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              let windowId = window.identifier?.rawValue,
              windowId.hasPrefix("BrowserWindow")
        else { return }
        
        windowWasClosed = true
        saveWindowPositionAndSize(window)
    }
    
    /// Save the window position and size when the window is closed
    /// - Parameter window: The window to save the position and size
    /// - Note: Only save the window position and size if the window is a BrowserWindow
    func saveWindowPositionAndSize(_ window: NSWindow) {
        guard !windowWasClosed else { return }
        guard let windowId = window.identifier?.rawValue,
              windowId.hasPrefix("BrowserWindow") else {
            return
        }
        
        let windowFrame = window.frame
        UserDefaults.standard.set(windowFrame.origin.x, forKey: "windowOriginX")
        UserDefaults.standard.set(windowFrame.origin.y, forKey: "windowOriginY")
        UserDefaults.standard.set(windowFrame.size.width, forKey: "windowWidth")
        UserDefaults.standard.set(windowFrame.size.height, forKey: "windowHeight")
    }
}
