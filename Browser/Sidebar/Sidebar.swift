//
//  Sidebar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct Sidebar: View {
    
    @EnvironmentObject var preferences: UserPreferences
    
    var body: some View {
        VStack {
            Text("URL")
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Text("Sidebar")
                }
                .background(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    func toggleSidebar() {
        preferences.showSidebar.toggle()
    }
}

#Preview {
    Sidebar()
}
