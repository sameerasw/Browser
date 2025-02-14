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
    
    let browserSpaces: [BrowserSpace]
    
    var body: some View {
        HStack {
            Button("Downloads", systemImage: "arrow.down.circle") {
                
            }
            .buttonStyle(.sidebarHover(padding: 2))
            
            SidebarSpaceList(browserSpaces: browserSpaces)
            
            Button("New Space", systemImage: "plus.circle.dashed") {
                withAnimation(.browserDefault) {
                    sidebarModel.showBottomNewMenu.toggle()
                }
            }
            .buttonStyle(.sidebarHover(padding: 2, rotationDegrees: sidebarModel.showBottomNewMenu ? 45 : 0))
        }
        .padding(.leading, .sidebarPadding)
    }
}

#Preview {
    SidebarBottomToolbar(browserSpaces: [])
}
