//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var preferences: UserPreferences
    
    var body: some View {
        ZStack {
            HStack {
                if preferences.sidebarPosition == .leading {
                    Sidebar()
                        .transition(.move(edge: .leading))
                }
                
                Text("Web Content")
                    .transition(.move(edge: preferences.sidebarPosition == .leading ? .trailing : .leading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if preferences.sidebarPosition == .trailing {
                    Sidebar()
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeOut, value: preferences.sidebarPosition)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView()
}
