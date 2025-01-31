//
//  SidebarSpaceIcon.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

struct SidebarSpaceIcon: View {
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        Button(browserSpace.name, systemImage: browserSpace.systemImage, action: setBrowserSpace)
        .buttonStyle(.sidebarHover())
        .foregroundStyle(browserWindowState.currentSpace == browserSpace ? .secondary : .tertiary)
        .contextMenu {
            Divider()
            Button("Delete Space", action: deleteSpace)
        }
    }
    
    func setBrowserSpace() {
        withAnimation(.bouncy) {
            browserWindowState.currentSpace = browserSpace
            browserWindowState.viewScrollState = browserSpace.id
            browserWindowState.tabBarScrollState = browserSpace.id
        }
    }
    
    func deleteSpace() {
        withAnimation(.bouncy) {
            modelContext.delete(browserSpace)
            try? modelContext.save()
        }
    }
}

#Preview {
    SidebarSpaceIcon(browserSpace: BrowserSpace(name: "Space 1", systemImage: "pencil", colors: [.black, .blue], colorScheme: "light"))
}
