//
//  Sidebar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct Sidebar: View {
    
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var sidebarModel: SidebarModel
    
    var body: some View {
        VStack {
            SidebarToolbar()
            
            Text("URL")
            
            ScrollView {
                Text("Hi")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: sidebarModel.currentSidebarWidth, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .gesture(WindowDragGesture()) // Move the browser window by dragging the sidebar
    }
}

#Preview {
    Sidebar()
}
