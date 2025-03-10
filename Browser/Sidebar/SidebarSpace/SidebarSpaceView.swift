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
        VStack(alignment: .leading, spacing: 0) {
            Label(browserSpace.name, systemImage: browserSpace.systemImage)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .padding(.leading, .sidebarPadding * 2)
            // This is a workaround to prevent the label from appearing from the bottom
                .transaction { $0.animation = nil }
                .frame(height: 25)
            
            ScrollView {
                VStack {
                    SidebarTabList(browserSpace: browserSpace, tabs: $browserSpace.pinnedTabs)
                        .padding(.top, 5)
                        .padding(.bottom, -5)
                    
                    SidebarSpaceClearDivider(browserSpace: browserSpace, isHovering: isHovering)
                    
                    SidebarTabNewButton(browserSpace: browserSpace)
                        .padding(.bottom, -3)
                    
                    SidebarTabList(browserSpace: browserSpace, tabs: $browserSpace.tabs)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sidebarSpaceContextMenu(browserSpaces: browserSpaces, browserSpace: browserSpace)
        .onHover { isHover in
            withAnimation(.browserDefault) {
                self.isHovering = isHover
            }
        }
    }
}
