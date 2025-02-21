//
//  Sidebar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

/// The main sidebar view
struct Sidebar: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    
    @EnvironmentObject var userPreferences: UserPreferences
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    let browserSpaces: [BrowserSpace]
    
    var body: some View {
        VStack {
            SidebarToolbar(browserSpaces: browserSpaces)
            SidebarURL()
            SidebarSpacesTabView(browserSpaces: browserSpaces, browserWindowState: browserWindowState)
            SidebarBottomToolbar(browserSpaces: browserSpaces)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.bottom, 10)
        .opacity(sidebarModel.currentSidebarWidth == 0 ? 0 : 1)
        .padding(.trailing, userPreferences.sidebarPosition == .trailing ? .sidebarPadding * 2 : 0)
        .gesture(WindowDragGesture()) // Move the browser window by dragging the sidebar
        .overlay(alignment: .bottomTrailing) {
            if sidebarModel.showBottomNewMenu {
                SidebarBottomAddMenu(createSpace: createSpace, disableNewTabButton: browserSpaces.isEmpty)
            }
        }
        .onAppear {
            if browserSpaces.isEmpty {
                createSpace()
            }
        }
    }
    
    func createSpace() {
        do {
            let nextIndex = browserSpaces.firstIndex(where: { $0.id == browserWindowState.currentSpace?.id }) ?? -1 + 1
            
            var newSpace: BrowserSpace
                        
            if browserWindowState.isMainBrowserWindow {
                newSpace = BrowserSpace(name: "", systemImage: "circle.fill", order: nextIndex, colors: [], colorScheme: "system")
            } else {
                newSpace = BrowserSpace(name: "Temporary Window", systemImage: "circle.fill", order: 0, colors: [], colorScheme: "system")
            }
            
            modelContext.insert(newSpace)
            try? modelContext.save()
            
            // Update all spaces order
            for (index, space) in browserSpaces.enumerated() {
                space.order = index
            }
            try modelContext.save()
            
            // Select the new space
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                browserWindowState.goToSpace(newSpace)
            }
        } catch {
            NSAlert(error: error).runModal()
        }
    }
}
