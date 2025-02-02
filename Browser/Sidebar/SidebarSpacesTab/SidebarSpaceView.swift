//
//  SidebarSpaceView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

struct SidebarSpaceView: View {
    
    @Environment(\.modelContext) var modelContext
    
    let browserSpaces: [BrowserSpace]
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        VStack(spacing: 0) {
            Label(browserSpace.name, systemImage: browserSpace.systemImage)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, .sidebarPadding * 2)
            
            Divider()
                .padding(.leading, .sidebarPadding * 2)
                .padding(.trailing, .sidebarPadding)
                .padding(.top)
            
            ScrollView {
                SidebarTabNewButton(browserSpace: browserSpace)
                    .padding(.top, 5)
                    .padding(.bottom, -3)
                
                SidebarTabList(browserSpace: browserSpace)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sidebarSpaceContextMenu(browserSpaces: browserSpaces, browserSpace: browserSpace)
    }
}
