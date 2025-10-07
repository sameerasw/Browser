//
//  HandleContextMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/12/25.
//

import Foundation
import AppKit

extension MyWKWebView {
    /// Handle the context menu
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
        case .text:
            handleTextContextMenu(menu)
        case .link:
            handleLinkContextMenu(menu)
        default:
            break
        }
        
        if contextMenuType == .unknown {
            print("🖥️📚 Unknown context menu type with identifiers:", menuItemsIdentifiers)
        } else {
            print("🖥️📚 Context menu type: \(contextMenuType.rawValue)")
        }
    }
}
