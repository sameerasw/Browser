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
        
        if contextMenuType == .unknown {
            print(menuItemsIdentifiers)
        } else {
            print("🔵 Context menu type: \(contextMenuType.rawValue)")
        }
    }
}
