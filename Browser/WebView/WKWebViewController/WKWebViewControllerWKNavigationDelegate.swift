//
//  WKWebViewControllerWKNavigationDelegate.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import WebKit

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print("🔵 Loading \(url.absoluteString)")
        
        if self.tab.url.cleanHost != url.cleanHost {
            print("🔵 New domain detected")
            self.tab.updateFavicon(with: url)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print("🟢 Finished loading \(url.absoluteString)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let url = webView.url else { return }
        print("🔴 Failed loading \(url.absoluteString) with error: \(error.localizedDescription)")
    }
}
