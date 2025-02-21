//
//  SidebarTabList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import SwiftUI

/// List of tabs of a space in the sidebar
struct SidebarTabList: View {
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    @EnvironmentObject var userPreferences: UserPreferences
    
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(browserSpace.tabs) { browserTab in
                SidebarTab(browserSpace: browserSpace, browserTab: browserTab)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, .sidebarPadding)
        .padding(.trailing, userPreferences.sidebarPosition == .leading && sidebarModel.sidebarCollapsed ? 5 : 0)
    }
}
