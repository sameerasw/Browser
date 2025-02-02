//
//  SidebarSpaceView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

struct SidebarSpaceView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        VStack {
            Label(browserSpace.name, systemImage: browserSpace.systemImage)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, .sidebarPadding * 2)
            
            Divider()
            
            ScrollView {
                SidebarTabNewButton(browserSpace: browserSpace)
                    .padding(.bottom, -3)
                
                SidebarTabList(browserSpace: browserSpace)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .contextMenu {
            SidebarSpaceContextMenu(browserSpace: browserSpace)
        }
    }
}
