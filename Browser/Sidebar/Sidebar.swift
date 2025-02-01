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
    
    @Query(animation: .bouncy) var browserSpaces: [BrowserSpace]
    
    var body: some View {
        VStack {
            SidebarToolbar()
            
            Text("Link goes here")
            
            SidebarSpacesTabView(browserSpaces: browserSpaces)
            SidebarBottomToolbar(browserSpaces: browserSpaces)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .gesture(WindowDragGesture()) // Move the browser window by dragging the sidebar
        .padding(.bottom, 10)
    }
}

#Preview {
    Sidebar()
}
