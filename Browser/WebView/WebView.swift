//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct WebView: View {
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    @EnvironmentObject var sidebarModel: SidebarModel
    
    var body: some View {
        ZStack {
            if let currentSpace = browserWindowState.currentSpace, let currentTab = currentSpace.currentTab {
                ForEach(currentSpace.tabs.filter { currentSpace.loadedTabs.contains($0) || $0 == currentTab }) { tab in
                    WKWebViewRepresentable(tab: tab)
                        .zIndex(tab == currentTab ? 1 : 0)
                        .onAppear {
                            currentSpace.loadedTabs.append(tab)
                            tab.updateFavicon(with: tab.url)
                        }
                }
            } else {
                Rectangle()
                    .fill(.regularMaterial)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .overlay {
            Button("Sidebar", action: sidebarModel.toggleSidebar)
        }
    }
}

#Preview {
    WebView()
}
