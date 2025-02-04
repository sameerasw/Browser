//
//  SidebarSpaceView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

// View that represents a space in the sidebar
struct SidebarSpaceView: View {
    
    @Environment(\.modelContext) var modelContext
    
    let browserSpaces: [BrowserSpace]
    
    @Bindable var browserSpace: BrowserSpace
    
    @State var isHovering = false
    @State var isHoveringClearButton = false
    
    var body: some View {
        LazyVStack(spacing: 0) {
            Label(browserSpace.name, systemImage: browserSpace.systemImage)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, .sidebarPadding * 2)
            
            SidebarSpaceClearDivider(browserSpace: browserSpace, isHovering: isHovering)
            
            ScrollView {
                VStack {
                    SidebarTabNewButton(browserSpace: browserSpace)
                        .padding(.top, 5)
                        .padding(.bottom, -3)
                    
                    SidebarTabList(browserSpace: browserSpace)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sidebarSpaceContextMenu(browserSpaces: browserSpaces, browserSpace: browserSpace)
        .onHover { isHover in
            self.isHovering = isHover
        }
    }
}
