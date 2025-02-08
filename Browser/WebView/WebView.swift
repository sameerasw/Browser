//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// View that contains a stack for the loaded tabs in the current space
struct WebView: View {

    @Environment(\.modelContext) var modelContext
    
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        ZStack {
            if let currentTab = browserSpace.currentTab {
                ForEach(browserSpace.tabs.filter { browserSpace.loadedTabs.contains($0) || $0 == currentTab }) { tab in
                    WKWebViewControllerRepresentable(tab: tab, browserSpace: browserSpace)
                        .zIndex(tab == currentTab ? 1 : 0)
                        .onAppear {
                            browserSpace.loadedTabs.append(tab)
                            tab.updateFavicon(with: tab.url)
                        }
                }
            } else {
                // Show a blank page if there is no current space or tab
                Rectangle()
                    .fill(.regularMaterial)
            }
        }
    }
}
