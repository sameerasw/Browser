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
    var userPreferences: UserPreferences

    var webView: MyWKWebView
    let configuration: WKWebViewConfiguration

    weak var coordinator: WKWebViewControllerRepresentable.Coordinator!

    var activeDownloads: [(download: WKDownload, bookmarkData: Data, fileName: String)] = []

    private var suspendTimer: DispatchSourceTimer?

    init(tab: BrowserTab, browserSpace: BrowserSpace, noTrace: Bool = false, using modelContext: ModelContext, userPreferences: UserPreferences) {
        self.tab = tab
        self.browserSpace = browserSpace
        self.userPreferences = userPreferences

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

        // Make webView background transparent
        webView.setValue(false, forKey: "drawsBackground")
        webView.wantsLayer = true
        webView.layer?.backgroundColor = NSColor.clear.cgColor

        webView.navigationDelegate = self
        webView.uiDelegate = self

        webView.searchWebAction = coordinator.searchWebAction(_:)
        webView.openLinkInNewTabAction = coordinator.openLinkInNewTabAction(_:)
        webView.presentActionAlert = coordinator.presentActionAlert(message:systemImage:)

        coordinator.observeWebView(webView)

        webView.load(URLRequest(url: tab.url))

        startSuspendTimer()
    }

    deinit {
        print("🔵 WKWebViewController deinit \(tab.title)")
        cleanup()
    }

    func cleanup() {
        // Only deinit if the tab is not loaded or was closed
        if !browserSpace.loadedTabs.contains(tab) {
            webView.stopLoading()
            webView.loadHTMLString("", baseURL: nil)
            webView.removeFromSuperview()
            coordinator.stopObservingWebView()
        }
    }

    func startSuspendTimer() {
        guard UserDefaults.standard.bool(forKey: "automatic_page_suspension") else { return }
        suspendTimer?.cancel()

        suspendTimer = DispatchSource.makeTimerSource(queue: .main)
        suspendTimer?.schedule(deadline: .now() + 60 * 30) // 30 minutes
        suspendTimer?.setEventHandler {
            // Don't suspend if the tab is currently active.
            if self.browserSpace.currentTab == self.tab {
                self.resetSuspendTimer()
            } else {
                print("🔵 WKWebViewController suspend \(self.tab.title)")
                self.coordinator.parent.browserSpace.unloadTab(self.coordinator.parent.tab)
            }
        }

        suspendTimer?.resume()
    }

    func resetSuspendTimer() {
        startSuspendTimer()
    }

    func applyTransparency() {
        let js: String
        if userPreferences.webContentTransparency {
            // Get the appropriate CSS from StyleManager
            let cssContent: String
            if let url = webView.url, let style = StyleManager.shared.getStyle(for: url) {
                cssContent = style
            } else {
                // Fallback to basic transparency if no styles available
                cssContent = "body { background-color: transparent !important; }"
            }
            
            // Properly escape the CSS content for JavaScript
            let escapedCSS = cssContent
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "`", with: "\\`")
                .replacingOccurrences(of: "$", with: "\\$")
            
            js = """
            (function() {
                var style = document.getElementById('transparency-style');
                if (!style) {
                    style = document.createElement('style');
                    style.id = 'transparency-style';
                    document.head.appendChild(style);
                }
                style.textContent = `\(escapedCSS)`;
            })();
            """
        } else {
            js = """
            (function() {
                var style = document.getElementById('transparency-style');
                if (style) {
                    style.remove();
                }
            })();
            """
        }
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
