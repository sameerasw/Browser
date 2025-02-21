//
//  WKWebViewControllerRepresentable.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import SwiftUI

/// WKWebViewController wrapper for SwiftUI
struct WKWebViewControllerRepresentable: NSViewControllerRepresentable {
    
    @Environment(\.modelContext) var modelContext
        
    @Bindable var browserSpace: BrowserSpace
    @Bindable var tab: BrowserTab
    let noTrace: Bool
    
    init(tab: BrowserTab, browserSpace: BrowserSpace, noTrace: Bool = false) {
        self.tab = tab
        self.browserSpace = browserSpace
        self.noTrace = noTrace
    }
    
    func makeNSViewController(context: Context) -> WKWebViewController {
        WKWebViewController(tab: tab, browserSpace: browserSpace, noTrace: noTrace, using: modelContext)
    }
    
    func updateNSViewController(_ nsViewController: WKWebViewController, context: Context) {
        nsViewController.webView.isHidden = tab != browserSpace.currentTab
                                            || tab.webviewErrorDescription != nil
                                            || tab.webviewErrorCode != nil
    }
}
