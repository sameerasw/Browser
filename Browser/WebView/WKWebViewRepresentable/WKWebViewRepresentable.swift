//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI
import WebKit

class SharedWebViewConfiguration {
    // Singleton to ensure a single shared configuration across tabs
    static let shared = SharedWebViewConfiguration()
    
    // Shared configuration with cache, cookies, and other settings
    let configuration: WKWebViewConfiguration
    
    private init() {
        configuration = WKWebViewConfiguration()
        
        configuration.allowsInlinePredictions = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.websiteDataStore = .default()
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Configure shared preferences
        let preferences = WKPreferences()
        preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        configuration.preferences = preferences
        
        
        let webPagePreferences = WKWebpagePreferences()
        webPagePreferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = webPagePreferences
    }
}

struct WKWebViewRepresentable: NSViewRepresentable {
    
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: SharedWebViewConfiguration.shared.configuration)
       
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15"
        webView.allowsLinkPreview = true
        webView.allowsMagnification = true
        webView.allowsLinkPreview = false // TODO: Implement my own preview later...
        webView.isInspectable = true
        
        webView.navigationDelegate = context.coordinator.navigationDelegateCoordinator
        webView.uiDelegate = context.coordinator.uiDelegateCoordinator
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        nsView.load(request)
    }
    
    func makeCoordinator() -> WKCoordinator {
        WKCoordinator(self)
    }
}
