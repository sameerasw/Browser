//
//  WebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct WebView: View {
    
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var sidebarModel: SidebarModel
    
    var body: some View {
        WKWebViewRepresentable(url: URL(string: "https://www.apple.com")!)
            .overlay {
                Button("Sidebar", action: sidebarModel.toggleSidebar) 
            }
    }
}

#Preview {
    WebView()
}
