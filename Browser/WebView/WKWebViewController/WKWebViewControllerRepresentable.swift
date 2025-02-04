//
//  WKWebViewControllerRepresentable.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import SwiftUI

/// WKWebViewController wrapper for SwiftUI
struct WKWebViewControllerRepresentable: NSViewControllerRepresentable {
    
    @Bindable var browserSpace: BrowserSpace
    @Bindable var tab: BrowserTab
    let incognito: Bool
    
    init(tab: BrowserTab, browserSpace: BrowserSpace, incognito: Bool = false) {
        self.tab = tab
        self.browserSpace = browserSpace
        self.incognito = incognito
    }
    
    func makeNSViewController(context: Context) -> WKWebViewController {
        WKWebViewController(tab: tab, browserSpace: browserSpace, incognito: incognito)
    }
    
    func updateNSViewController(_ nsViewController: WKWebViewController, context: Context) {}
}
