//
//  SidebarToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct SidebarToolbar: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var sidebarModel: SidebarModel
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                if userPreferences.sidebarPosition == .leading {
                    TrafficLights()
                }
                
                SidebarToolbarButton(userPreferences.sidebarPosition == .leading ? "sidebar.left" : "sidebar.right", action: sidebarModel.toggleSidebar)
                    .padding(.leading, userPreferences.sidebarPosition == .trailing ? 5 : 0)
                
                Spacer()
                
                SidebarToolbarButton("arrow.left", disabled: (browserWindowState.currentSpace?.currentTab?.canGoBack ?? false) == false) {
                    browserWindowState.currentSpace?.currentTab?.webview?.goBack()
                }
                
                SidebarToolbarButton("arrow.right", disabled: (browserWindowState.currentSpace?.currentTab?.canGoForward ?? false) == false) {
                    browserWindowState.currentSpace?.currentTab?.webview?.goForward()
                }
                
                SidebarToolbarButton("arrow.trianglehead.clockwise", disabled: browserWindowState.currentSpace?.currentTab == nil) {
                    browserWindowState.currentSpace?.currentTab?.webview?.reload()
                }
            }
            .frame(alignment: .top)
            .padding(.top, .approximateTrafficLightsTopPadding)
            .padding(.trailing, .sidebarPadding)
        }
    }
}

#Preview {
    SidebarToolbar()
}
