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
    
    weak var coordinator: WKWebViewControllerRepresentable.Coordinator!
    
    var activeDownloads: [(download: WKDownload, bookmarkData: Data, fileName: String)] = []
    
    init(tab: BrowserTab, browserSpace: BrowserSpace, noTrace: Bool = false, using modelContext: ModelContext) {
        self.tab = tab
        self.browserSpace = browserSpace
        
        self.configuration = SharedWebViewConfiguration.shared.configuration
        if noTrace {
            self.configuration.websiteDataStore = .nonPersistent()
        }
                
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
                
        webView.searchWebAction = coordinator.searchWebAction(_:)
        webView.openLinkInNewTabAction = coordinator.openLinkInNewTabAction(_:)
        webView.presentActionAlert = coordinator.presentActionAlert(message:systemImage:)
        
        coordinator.observeWebView(webView)
        
        webView.load(URLRequest(url: tab.url))
    }
    
    deinit {
        // Only deinit if the tab is not loaded or was closed
        if !browserSpace.loadedTabs.contains(tab) {
            print("🔵 WKWebViewController deinit \(tab.title)")
            webView.stopLoading()
            webView.loadHTMLString("", baseURL: nil)
            webView.removeFromSuperview()
            coordinator.stopObservingWebView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
