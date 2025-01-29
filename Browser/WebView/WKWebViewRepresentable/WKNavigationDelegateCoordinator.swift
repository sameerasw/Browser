//
//  WKNavigationDelegateCoordinator.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import WebKit

class WKNavigationDelegateCoordinator: NSObject, WKNavigationDelegate {
    
    var parent: WKWebViewRepresentable
    
    init(_ parent: WKWebViewRepresentable) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("🔵 Loading \(webView.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("🟢 Finished loading \(webView.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("🔴 Failed loading \(webView.url?.absoluteString ?? "") with error: \(error.localizedDescription)")
    }
}
