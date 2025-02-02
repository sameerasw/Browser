//
//  WKWebViewController.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import SwiftUI
import WebKit

class WKWebViewController: NSViewController {
    
    @Bindable var tab: BrowserTab
    
    var webView: MyWKWebView!
    let configuration: WKWebViewConfiguration
    
    init(tab: BrowserTab, incognito: Bool = false) {
        self.tab = tab
        self.configuration = SharedWebViewConfiguration.shared.configuration
        if incognito {
            self.configuration.websiteDataStore = .nonPersistent()
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        webView = MyWKWebView(frame: .zero, configuration: configuration)
        view = webView
        
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15"
        webView.allowsLinkPreview = true
        webView.allowsMagnification = true
        webView.allowsLinkPreview = false // TODO: Implement my own preview later...
        webView.isInspectable = true
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.load(URLRequest(url: tab.url))
        
        tab.webview = webView
    }
    
    deinit {
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
        webView.removeFromSuperview()
    }
    
//    override func viewWillDisappear() {
//        print("🔵 WKWebViewController viewWillDisappear")
//        super.viewWillDisappear()
//        webView.stopLoading()
//        webView.loadHTMLString("", baseURL: nil)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
