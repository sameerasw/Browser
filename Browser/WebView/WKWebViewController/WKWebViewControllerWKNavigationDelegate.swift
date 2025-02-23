//
//  WKWebViewControllerWKNavigationDelegate.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import WebKit

/// WKNavigationDelegate implementation for WKWebViewController
extension WKWebViewController: WKNavigationDelegate {
    
    /// Called when the web view starts loading a page
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print("🔵 Loading \(url.absoluteString)")
        
        if self.tab.url.cleanHost != url.cleanHost {
            print("🔵 New domain detected")
            self.tab.updateFavicon(with: url)
        }
    }
    
    /// Called when the web view finishes loading a page
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print("🟢 Finished loading \(url.absoluteString)")
        
        coordinator.addTabToHistory()
        
        self.webView.setZoomFactor(self.webView.savedZoomFactor())
        
        tab.webviewErrorCode = nil
        tab.webviewErrorDescription = nil
    }
    
    /// Called when the web view fails loading a page
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let url = webView.url else { return }
        print("🔴 Failed loading \(url.absoluteString) with error: \(error.localizedDescription)")
    }
    
    /// Called when the web view wants to create a new web view (open new tab)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        coordinator.createNewTabFromAction(navigationAction)
        return nil
    }
    
    /// Decided what type of navigation to allow (download, allow.)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping @MainActor (WKNavigationResponsePolicy) -> Void) {
        guard navigationResponse.response.mimeType != nil else {
            decisionHandler(.allow)
            return
        }
        
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
        } else {
            print("🔵 Decision is of type download")
            decisionHandler(.download)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        let error = error as NSError
        tab.webviewErrorDescription = error.localizedDescription
        tab.webviewErrorCode = error.code
        print("🔴 Failed provisional navigation with error: \(error.localizedDescription) with code \(error.code)")
    }
}
