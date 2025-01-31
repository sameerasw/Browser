//
//  SidebarBottomToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

struct SidebarBottomToolbar: View {
    
    @Environment(\.modelContext) var modelContext
    let browserSpaces: [BrowserSpace]
    
    var body: some View {
        HStack {
            Button("Downloads", systemImage: "arrow.down.circle.fill") {
                
            }
            .labelStyle(.iconOnly)
            
            SidebarSpaceList(browserSpaces: browserSpaces)
            
            Button("New Space", systemImage: "plus.circle.dashed") {
                modelContext.insert(BrowserSpace(name: "Space", systemImage: "pencil", colors: [], colorScheme: "Light"))
                try? modelContext.save()
            }
            .labelStyle(.iconOnly)
        }
        .buttonStyle(.sidebarHover(padding: 2))
        .padding(.leading, .sidebarPadding)
    }
}

#Preview {
    SidebarBottomToolbar(browserSpaces: [])
}
