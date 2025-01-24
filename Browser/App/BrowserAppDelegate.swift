//
//  BrowserAppDelegate.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import AppKit

class BrowserAppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var window: NSWindow!
    var windowWasClosed = false
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeKey(_:)), name: NSWindow.didBecomeKeyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(_:)), name: NSWindow.willCloseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResizeOrMove(_:)), name: NSWindow.didMoveNotification, object: window)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResizeOrMove(_:)), name: NSWindow.didResizeNotification, object: window)
    }
    
    @objc func windowDidBecomeKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
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
        }
    }
    
    @objc func windowDidResizeOrMove(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            saveWindowPositionAndSize(window)
        }
    }
    
    @objc func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            windowWasClosed = true
            saveWindowPositionAndSize(window)
        }
    }
    
    func saveWindowPositionAndSize(_ window: NSWindow) {
        guard !windowWasClosed else { return }
        let windowFrame = window.frame
        UserDefaults.standard.set(windowFrame.origin.x, forKey: "windowOriginX")
        UserDefaults.standard.set(windowFrame.origin.y, forKey: "windowOriginY")
        UserDefaults.standard.set(windowFrame.size.width, forKey: "windowWidth")
        UserDefaults.standard.set(windowFrame.size.height, forKey: "windowHeight")
    }
}
