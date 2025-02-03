//
//  MyWKWebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import WebKit

enum ContextMenuType: String {
    case frame = "WKMenuItemIdentifierReload"
    case text = "WKMenuItemIdentifierTranslate"
    case link = "WKMenuItemIdentifierOpenLink"
    case image = "WKMenuItemIdentifierCopyImage"
    case media = "WKMenuItemIdentifierShowHideMediaControls"
    case unknown = "unknown"
}


class MyWKWebView: WKWebView {
    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        super.willOpenMenu(menu, with: event)
        
        // Detect menu type
        var contextMenuType: ContextMenuType = .unknown
        
        let menuItemsIdentifiers = menu.items.map { $0.identifier?.rawValue }
        
        for identifier in menuItemsIdentifiers {
            if let type = ContextMenuType(rawValue: identifier ?? "") {
                contextMenuType = type
                break
            }
        }
        
        switch contextMenuType {
        case .frame:
            handleFrameContextMenu(menu)
        default:
            break
        }
        
        if contextMenuType == .unknown {
            print(menuItemsIdentifiers)
        } else {
            print("🔵 Context menu type: \(contextMenuType.rawValue)")
        }
    }
    
    func handleFrameContextMenu(_ menu: NSMenu) {
        // Remove default back and forward items and add custom ones for consistency
        menu.items.removeAll { $0.identifier?.rawValue == "WKMenuItemIdentifierGoBack" }
        menu.items.removeAll { $0.identifier?.rawValue == "WKMenuItemIdentifierGoForward" }
        
        let backItem = NSMenuItem(title: "Back", action: #selector(goBackPage), keyEquivalent: "")
        backItem.isEnabled = canGoBack
        
        let forwardItem = NSMenuItem(title: "Forward", action: #selector(goForward(_:)), keyEquivalent: "")
        forwardItem.isEnabled = canGoForward
        
        menu.insertItem(backItem, at: 0)
        menu.insertItem(forwardItem, at: 1)
    }
    
    
    @objc func goBackPage() {
        goBack()
    }
    
    @objc func goForwardPage() {
        goForward()
    }
}
