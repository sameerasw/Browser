//
//  SidebarTabList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import SwiftUI

/// List of tabs of a space in the sidebar
struct SidebarTabList: View {
    
    @Environment(SidebarModel.self) var sidebarModel
    @EnvironmentObject var userPreferences: UserPreferences
    
    @Bindable var browserSpace: BrowserSpace
    
    @State var draggingTab: BrowserTab?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(browserSpace.tabs) { browserTab in
                SidebarTab(browserSpace: browserSpace, browserTab: browserTab, dragging: false)
                    .draggable(browserSpace.id.uuidString) {
                       SidebarTab(browserSpace: browserSpace, browserTab: browserTab, dragging: true)
                            .opacity(0.65)
                    }
                // Using simultaneousGesture because onAppear is causing unexpected behavior
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { _ in
                                if draggingTab == nil {
                                    draggingTab = browserTab
                                }
                            }
                    )
                    .dropDestination(for: String.self) { items, location in
                        withAnimation(.browserDefault) {
                            draggingTab = nil
                            
                        }
                        return false
                    } isTargeted: { status in
                        if status {
                            moveTab(to: browserTab)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, .sidebarPadding)
        .padding(.trailing, userPreferences.sidebarPosition == .leading && sidebarModel.sidebarCollapsed ? 5 : 0)
    }
    
    func moveTab(to destination: BrowserTab) {
        if let draggingTab, draggingTab != destination {
            if let sourceIndex = browserSpace.tabs.firstIndex(of: draggingTab),
               let destinationIndex = browserSpace.tabs.firstIndex(of: destination) {
                withAnimation(.browserDefault) {
                    let sourceItems = browserSpace.tabs.remove(at: sourceIndex)
                    browserSpace.tabs.insert(sourceItems, at: destinationIndex)
                }
            }
        }
    }
}
