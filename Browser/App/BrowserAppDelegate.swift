//
//  BrowserAppDelegate.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import AppKit

/// The app delegate is responsible for handling window events and saving the window position and size
class BrowserAppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var lastWindows: [NSWindow] = []
    var newWindowOpened = false
    var windowWasClosed = false
    
    var userPreferences = UserPreferences()
    
    /// Add window observers to save the window position and size
    func applicationWillFinishLaunching(_ notification: Notification) {        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeKey(_:)), name: NSWindow.didBecomeKeyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResizeOrMove(_:)), name: NSWindow.didResizeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResizeOrMove(_:)), name: NSWindow.didMoveNotification, object: nil)
        
        NSWindow.allowsAutomaticWindowTabbing = false
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        closeNotMainWindows()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        closeNotMainWindows()
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if userPreferences.warnBeforeQuitting {
            let alert = NSAlert()
            alert.messageText = "Are you sure you want to quit?"
            alert.addButton(withTitle: "Cancel")
            alert.addButton(withTitle: "Quit").hasDestructiveAction = true
            
            let checkbox = NSButton(checkboxWithTitle: "Warn before quitting", target: self, action: #selector(setWarnBeforeQuitting(_:)))
            checkbox.state = .on
            
            alert.accessoryView = checkbox
                        
            if alert.runModal() == .alertFirstButtonReturn {
                return .terminateCancel
            } else {
                return .terminateNow
            }
        }
        
        return .terminateNow
    }
    
    /// Restore the window position and size when the window becomes key
    @objc func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              let windowId = window.identifier?.rawValue,
              windowId.contains("Browser")
        else { return }
        
        checkForNewWindows(window)
        
        if windowWasClosed || newWindowOpened {
            let windowOriginX = UserDefaults.standard.double(forKey: "windowOriginX")
            let windowOriginY = UserDefaults.standard.double(forKey: "windowOriginY")
            let windowWidth = UserDefaults.standard.double(forKey: "windowWidth")
            let windowHeight = UserDefaults.standard.double(forKey: "windowHeight")
            
            var frame = window.frame
            frame.origin.x = windowOriginX + (newWindowOpened ? 20 : 0)
            frame.origin.y = windowOriginY
            frame.size.width = windowWidth
            frame.size.height = windowHeight
            
            window.setFrame(frame, display: true)
            windowWasClosed = false
        }
        
        window.backgroundColor = .clear
        window.isReleasedWhenClosed = true
        window.delegate = self
        window.toolbar?.allowsDisplayModeCustomization = false
        
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
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        windowWasClosed = NSApp.windows.filter { $0.identifier?.rawValue.hasPrefix("BrowserWindow") == true }.count - 1 == 0
        return true
    }
    
    @objc func checkForNewWindows(_ sender: NSWindow) {
        let currentWindows = NSApp.windows.filter { $0.identifier?.rawValue.hasPrefix("BrowserWindow") == true }
        newWindowOpened = currentWindows.count > lastWindows.count || !lastWindows.compactMap { $0.identifier?.rawValue }.contains(sender.identifier?.rawValue)
        lastWindows = currentWindows
    }
    
    /// Save the window position and size when the window is closed
    /// - Parameter window: The window to save the position and size
    /// - Note: Only save the window position and size if the window is a BrowserWindow
    func saveWindowPositionAndSize(_ window: NSWindow) {
        guard !windowWasClosed || !newWindowOpened else { return }
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
    
    func closeNotMainWindows() {
        NSApp.windows.filter { $0.identifier?.rawValue.hasPrefix("BrowserWindow") == false }.forEach {
            $0.close()
        }
    }
    
    @objc func setWarnBeforeQuitting(_ sender: NSButton) {
        userPreferences.warnBeforeQuitting = sender.state == .on
    }
}
