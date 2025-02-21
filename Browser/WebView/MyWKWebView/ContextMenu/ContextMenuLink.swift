//
//  ContextMenuLink.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/20/25.
//

import WebKit

extension MyWKWebView {
    /// Creates the custom context menu for links
    /// - Parameter menu: The context menu to modify
    func handleLinkContextMenu(_ menu: NSMenu) {
        let openInNewTabItem = NSMenuItem(title: "Open Link in New Tab", action: #selector(openInNewTab), keyEquivalent: "")
        menu.insertItem(openInNewTabItem, at: 1)
    }
    
    @objc func openInNewTab() {
        let script = """
                (function() {
                    let selection = window.getSelection();
                    if (selection.rangeCount > 0) {
                        let range = selection.getRangeAt(0);
                        let element = range.commonAncestorContainer;
                
                        if (element.nodeType === 3) element = element.parentNode;
                
                        let link = element.closest('a');
                        return link ? link.href : null;
                    }
                    return null;
                })();
                """
        
        evaluateJavaScript(script) { result, error in
            guard error == nil else { return }
            
            if let urlString = result as? String, !urlString.isEmpty, let url = URL(string: urlString) {
                self.openLinkInNewTabAction?(url)
            }
        }
    }
}
