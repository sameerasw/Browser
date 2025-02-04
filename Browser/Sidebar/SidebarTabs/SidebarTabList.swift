//
//  SidebarTabList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import SwiftUI

/// List of tabs of a space in the sidebar
struct SidebarTabList: View {
    @Bindable var browserSpace: BrowserSpace
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            ForEach(browserSpace.tabs) { browserTab in
                SidebarTab(browserSpace: browserSpace, browserTab: browserTab)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, .sidebarPadding)
    }
}
