//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// View that contains a stack for the loaded tabs in the current space
struct WebView: View {
    
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        ZStack {
            if let currentTab = browserSpace.currentTab {
                ForEach(browserSpace.tabs.filter { browserSpace.loadedTabs.contains($0) || $0 == currentTab }) { tab in
                    Group {
                        switch tab.type {
                        case .web:
                            WKWebViewControllerRepresentable(tab: tab, browserSpace: browserSpace)
                                .onAppear {
                                    if tab.favicon == nil {
                                        tab.updateFavicon(with: tab.url)
                                    }
                                }
                        case .history:
                            HistoryView(browserTab: tab)
                        }
                    }
                    .zIndex(tab == currentTab ? 1 : 0)
                    .onAppear {
                        browserSpace.loadedTabs.append(tab)
                    }
                }
            } else {
                // Show a blank page if there is no current space or tab
                Rectangle()
                    .fill(.regularMaterial)
            }
        }
        .transaction { $0.animation = nil }
    }
}
