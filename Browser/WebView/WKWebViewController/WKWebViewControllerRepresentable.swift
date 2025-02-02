//
//  WKWebViewControllerRepresentable.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import SwiftUI

struct WKWebViewControllerRepresentable: NSViewControllerRepresentable {
    
    @Bindable var tab: BrowserTab
    let incognito: Bool
    
    init(tab: BrowserTab, incognito: Bool = false) {
        self.tab = tab
        self.incognito = incognito
    }
    
    func makeNSViewController(context: Context) -> WKWebViewController {
        WKWebViewController(tab: tab, incognito: incognito)
    }
    
    func updateNSViewController(_ nsViewController: WKWebViewController, context: Context) {
    }
}
