//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/20/25.
//

import SwiftUI

struct WebView: View {
    
    @Bindable var tab: BrowserTab
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        Group {
            switch tab.type {
            case .web:
                WKWebViewControllerRepresentable(tab: tab, browserSpace: browserSpace)
                    .opacity(tab.webviewErrorCode != nil ? 0 : 1)
                    .overlay {
                        if tab.webviewErrorDescription != nil && tab.webviewErrorCode != nil {
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
            }
        }
    }
}
