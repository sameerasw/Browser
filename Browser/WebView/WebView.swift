//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/20/25.
//

import SwiftUI

/// View that represents the webview of a tab, it can be a webview or a history view
struct WebView: View {
    
    @Environment(BrowserWindowState.self) var browserWindowState
    
    @Bindable var tab: BrowserTab
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        Group {
            switch tab.type {
            case .web:
                WKWebViewControllerRepresentable(tab: tab, browserSpace: browserSpace, noTrace: browserWindowState.isNoTraceWindow)
                    .opacity(tab.webviewErrorCode != nil ? 0 : 1)
                    .overlay {
                        if tab.webviewErrorDescription != nil, let errorCode = tab.webviewErrorCode, errorCode != -999 {
                            MyWKWebViewErrorView(tab: tab)
                        }
                    }
                    .onAppear {
                        if tab.favicon == nil {
                            tab.updateFavicon(with: tab.url)
                        }
                    }
            case .history:
                HistoryView(browserTab: tab)
                    .opacity(browserWindowState.currentSpace?.currentTab == tab ? 1 : 0)
            }
        }
    }
}
