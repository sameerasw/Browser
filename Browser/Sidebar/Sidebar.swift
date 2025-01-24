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
            SidebarToolbar()
            
            Text("URL")
            
            ScrollView {
                Text("Hi")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.pink)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
}

#Preview {
    Sidebar()
}
