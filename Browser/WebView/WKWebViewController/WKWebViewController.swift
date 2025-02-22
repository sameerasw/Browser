//
//  WKWebViewController.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import SwiftUI
import WebKit
import SwiftData

/// Main view controller that contains a WKWebView
class WKWebViewController: NSViewController {
        
    @Bindable var tab: BrowserTab
    @Bindable var browserSpace: BrowserSpace
    
    var webView: MyWKWebView
    let configuration: WKWebViewConfiguration
    
    let modelContext: ModelContext
    
    weak var browserWindowState: BrowserWindowState!
    
    var activeDownloads: [(download: WKDownload, bookmarkData: Data, fileName: String)] = []
    
    init(tab: BrowserTab, browserSpace: BrowserSpace, noTrace: Bool = false, using modelContext: ModelContext) {
        self.tab = tab
        self.browserSpace = browserSpace
        
        self.configuration = SharedWebViewConfiguration.shared.configuration
        if noTrace {
            self.configuration.websiteDataStore = .nonPersistent()
        }
        
        self.modelContext = modelContext
        
        self.webView = MyWKWebView(frame: .zero, configuration: self.configuration)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = webView
        
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15 (Browser)"
        webView.allowsMagnification = true
        webView.allowsLinkPreview = true // TODO: Implement my own preview later...
        webView.isInspectable = true
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.searchWebAction = searchWebAction
        webView.openLinkInNewTabAction = openLinkInNewTabAction
        webView.presentActionAlert = presentActionAlert(message:systemImage:)
        
        webView.load(URLRequest(url: tab.url))
        tab.webview = webView
    }
    
    deinit {
        // Only deinit if the tab is not loaded or was closed
        if !browserSpace.loadedTabs.contains(tab) {
            print("🔵 WKWebViewController deinit \(tab.title)")
            webView.stopLoading()
            webView.loadHTMLString("", baseURL: nil)
            webView.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchWebAction(_ query: String) {
        let newTab = BrowserTab(title: query, url: URL(string: "https://www.google.com/search?q=\(query)")!, order: tab.order + 1, browserSpace: browserSpace)
        browserSpace.openNewTab(newTab, using: modelContext)
    }
    
    func openLinkInNewTabAction(_ url: URL) {
        let newTab = BrowserTab(title: url.cleanHost, url: url, order: tab.order + 1, browserSpace: browserSpace)
        browserSpace.openNewTab(newTab, using: modelContext, select: false)
    }
    
    func presentActionAlert(message: String, systemImage: String) {
        browserWindowState.presentActionAlert(message: message, systemImage: systemImage)
    }
}
