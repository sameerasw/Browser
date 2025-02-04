//
//  Sidebar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

/// The main sidebar view
struct Sidebar: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var browserWindowState: BrowserWindowState
    @EnvironmentObject var sidebarModel: SidebarModel
    
    @Query(animation: .bouncy) var browserSpaces: [BrowserSpace]
    
    var body: some View {
        VStack {
            SidebarToolbar()
            
            Button("Link Goes Here") {
                browserWindowState.searchOpenLocation = .fromURLBar
            }
            
            SidebarSpacesTabView(browserSpaces: browserSpaces)
            SidebarBottomToolbar(browserSpaces: browserSpaces)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.bottom, 10)
        .opacity(sidebarModel.currentSidebarWidth == 0 ? 0 : 1)
        .padding(.trailing, userPreferences.sidebarPosition == .trailing ? .sidebarPadding * 2 : 0)
        .gesture(WindowDragGesture()) // Move the browser window by dragging the sidebar
    }
}

#Preview {
    Sidebar()
}
