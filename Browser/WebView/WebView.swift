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
        Group {
            if browserWindowState.currentSpace?.currentTab == nil {
                Rectangle()
                    .fill(.regularMaterial)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
//                WKWebViewRepresentable(browserTab: browserWindowState.currentTab)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .layoutPriority(1)
        .overlay {
            Button("Sidebar", action: sidebarModel.toggleSidebar)
        }
    }
}

#Preview {
    WebView()
}
