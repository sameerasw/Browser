//
//  MainFrame.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct MainFrame: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    @StateObject var sidebarModel = SidebarModel()
    
    var body: some View {
        HStack(spacing: 0) {
            if userPreferences.sidebarPosition == .leading {
                if !sidebarModel.sidebarCollapsed {
                    Sidebar()
                        .frame(width: sidebarModel.currentSidebarWidth)
                        .readingWidth(width: $sidebarModel.currentSidebarWidth)
                    SidebarResizer()
                }
            }
            
            WebView()
                .clipShape(.rect(cornerRadius: 8))
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 10)
                .padding(userPreferences.sidebarPosition == .leading ? .leading : .trailing, 5)
                .padding([userPreferences.sidebarPosition == .leading ? .trailing : .leading], 10)
            
            if userPreferences.sidebarPosition != .leading {
                if !sidebarModel.sidebarCollapsed {
                    SidebarResizer()
                    Sidebar()
                        .frame(width: sidebarModel.currentSidebarWidth)
                        .readingWidth(width: $sidebarModel.currentSidebarWidth)
                }
            }
        }
        .animation(userPreferences.disableAnimations ? nil : .bouncy, value: userPreferences.sidebarPosition)
        .frame(maxWidth: .infinity)
        .toolbar { Text("") }
        .environmentObject(sidebarModel)
    }
}
