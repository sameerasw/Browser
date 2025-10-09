//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// View that contains a stack for the loaded tabs in the current space
struct WebViewStack: View {
    @Bindable var browserSpace: BrowserSpace
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            if let currentTab = browserSpace.currentTab {
                ForEach(browserSpace.allTabs.filter { browserSpace.loadedTabs.contains($0) || $0 == currentTab }) { tab in
                    WebView(tab: tab, browserSpace: browserSpace)
                    .zIndex(tab == currentTab ? 1 : 0)
                    .opacity(tab == currentTab ? 1 : 0)
                    .scaleEffect(tab == currentTab ? 1 : 0.95)
                    .animation(.bouncy(duration: 0.3), value: browserSpace.currentTab)
                    .onAppear {
                        if !browserSpace.loadedTabs.contains(tab) {
                            browserSpace.loadedTabs.append(tab)
                        }
                    }
                }
            } else {
                // Show app logo in the empty area. Invert the image when in light mode
                // so it remains visible against a light background.

                Group {
                    if colorScheme == .light {
                        Image("logo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .opacity(0.3)
                            .colorInvert()
                    } else {
                        Image("logo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .opacity(0.3)
                    }
                }
            }
        }
        .transaction { $0.animation = .bouncy(duration: 0.3) }
    }
}
