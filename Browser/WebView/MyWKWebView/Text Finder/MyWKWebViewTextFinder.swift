//
//  MyWKWebViewTextFinder.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/23/25.
//

import WebKit

class WKWebViewTextFinder: NSTextFinder {
    var hideInterfaceCallback: (() -> Void)?
    
    override func performAction(_ op: NSTextFinder.Action) {
        super.performAction(op)
        
        if op == .hideFindInterface, let hideInterfaceCallback = hideInterfaceCallback {
            hideInterfaceCallback()
        }
    }
}
