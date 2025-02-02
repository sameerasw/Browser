//
//  SidebarSpaceContextMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/1/25.
//

import SwiftUI

struct SidebarSpaceContextMenu: ViewModifier {
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    @Environment(\.modelContext) var modelContext
    
    let browserSpaces: [BrowserSpace]
    @Bindable var browserSpace: BrowserSpace
    
    @State var showDeleteAlert = false
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button("Print") {
                    print("Print")
                }
                
                Divider()
                
                Button("Delete Space") {
                    showDeleteAlert.toggle()
                }
            }
            .alert("Delete \"\(browserSpace.name)\"", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel, action: {})
                Button("Delete", role: .destructive, action: deleteSpace)
            } message: {
                Text("This action cannot be undone. All tabs in this space will be lost.")
            }
    }
    
    func deleteSpace() {
        if browserWindowState.currentSpace == browserSpace {
            guard let index = browserSpaces.firstIndex(where: { $0.id == browserSpace.id }) else { return }
            let newSpace = browserSpaces[safe: index == 0 ? 1 : index - 1]
            
            if let newSpace {
                withAnimation(.bouncy) {
                    browserWindowState.currentSpace = newSpace
                    browserWindowState.viewScrollState = newSpace.id
                    browserWindowState.tabBarScrollState = newSpace.id
                }
            }
        }
        
        withAnimation(.bouncy) {
            modelContext.delete(browserSpace)
            try? modelContext.save()
        }
    }
}

extension View {
    func sidebarSpaceContextMenu(browserSpaces: [BrowserSpace], browserSpace: BrowserSpace) -> some View {
        modifier(SidebarSpaceContextMenu(browserSpaces: browserSpaces, browserSpace: browserSpace))
    }
}
