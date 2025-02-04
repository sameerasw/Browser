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
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    var body: some View {
        ZStack {
            if let currentSpace = browserWindowState.currentSpace, let currentTab = currentSpace.currentTab {
                ForEach(currentSpace.tabs.filter { currentSpace.loadedTabs.contains($0) || $0 == currentTab }) { tab in
                    WKWebViewControllerRepresentable(tab: tab, browserSpace: currentSpace)
                        .zIndex(tab == currentTab ? 1 : 0)
                        .onAppear {
                            currentSpace.loadedTabs.append(tab)
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

#Preview {
    WebView()
}
