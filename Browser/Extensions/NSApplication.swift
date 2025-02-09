//
//  Window.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/7/25.
//

import AppKit

extension NSApplication {
    func setBrowserWindowControls(hidden: Bool) {
        for window in windows where window.identifier?.rawValue.contains("BrowserWindow") == true {
            window.standardWindowButton(.closeButton)?.isHidden = hidden
            window.standardWindowButton(.miniaturizeButton)?.isHidden = hidden
            window.standardWindowButton(.zoomButton)?.isHidden = hidden
        }
    }
    
    func removeMenuItem(_ item: String, from menu: String) {
        if let menu = mainMenu?.item(withTitle: menu)?.submenu {
            if let item = menu.item(withTitle: item) {
                print("Hiding item \(item) from menu \(menu)")
                item.isHidden = true
                menu.removeItem(item)
            } else {
                print("Item \(item) not found in menu \(menu)")
            }
        } else {
            print("Menu \(menu) not found")
        }
    }
    
    func closeAllWindows() {
        windows.forEach { $0.close() }
    }
}
