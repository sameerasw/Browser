//
//  SidebarTabList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import SwiftUI

struct SidebarTabList: View {
    let browserTabs: [BrowserTab]
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 2) {
            ForEach(browserTabs) { browserTab in
                SidebarTab(browserTab: browserTab)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 5)
    }
}
