//
//  Sidebar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

struct Sidebar: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    @EnvironmentObject var sidebarModel: SidebarModel
    
    @Query(animation: .bouncy) var tabs: [BrowserTab]
    
    var body: some View {
        VStack {
            SidebarToolbar()
            
            Text(browserWindowState.currentTab?.url.absoluteString ?? "")
            
            Button("Add Tab") {
                withAnimation {
                    let newTab = BrowserTab(title: "New Tab", favicon: nil, url: URL(string: "google.com")!)
                    modelContext.insert(newTab)
                    try? modelContext.save()
                }
            }
            ScrollView {
                SidebarTabList(browserTabs: tabs)
            }
            .frame(maxWidth: sidebarModel.currentSidebarWidth, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            
            SidebarSpaceList()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .gesture(WindowDragGesture()) // Move the browser window by dragging the sidebar
        .padding(.bottom, 10)
    }
}

#Preview {
    Sidebar()
}
