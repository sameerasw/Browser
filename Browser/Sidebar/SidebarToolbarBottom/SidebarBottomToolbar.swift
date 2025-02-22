//
//  SidebarBottomToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

/// Bottom toolbar for the sidebar
struct SidebarBottomToolbar: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    let browserSpaces: [BrowserSpace]
    let createSpace: () -> Void
    
    var body: some View {
        HStack {
            Button("Downloads", systemImage: "arrow.down.circle") {
                
            }
            .buttonStyle(.sidebarHover(padding: 2))
            
            Spacer()
            
            if browserWindowState.isMainBrowserWindow {
                SidebarSpaceList(browserSpaces: browserSpaces)
 
                Button("New Space", systemImage: "plus.circle.dashed", action: createSpace)
                    .buttonStyle(.sidebarHover(padding: 2))
            }
        }
        .padding(.leading, .sidebarPadding)
    }
}

#Preview {
    SidebarBottomToolbar(browserSpaces: [], createSpace: {})
}
