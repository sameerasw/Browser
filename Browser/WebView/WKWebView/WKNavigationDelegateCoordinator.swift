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
        guard let url = webView.url else { return }
        print("🔵 Loading \(url.absoluteString)")
        
        if self.parent.tab.url.cleanHost != url.cleanHost {
            print("🔵 New domain detected")
            self.parent.tab.updateFavicon(with: url)
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
