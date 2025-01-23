//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SplitView

struct ContentView: View {
    
    @EnvironmentObject var preferences: UserPreferences
    
    let sidebarFraction = FractionHolder.usingUserDefaults(0.20, key: "sidebar_fraction")
    let sidebarHide = SideHolder.usingUserDefaults(key: "sidebar_hide")
    
    var body: some View {
        ZStack {
            HSplit {
                Sidebar()
            } right: {
                Text("WebContent")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.blue)
            }
            .hide(sidebarHide)
            .fraction(sidebarFraction)
            .splitter { Splitter.invisible() }
            .styling(hideSplitter: true)
            .constraints(minPFraction: 0.15, minSFraction: 0.5, priority: .left, dragToHideP: true)
        }
        .padding(5)
        .ignoresSafeArea(.all, edges: .all)
    }
}

#Preview {
    ContentView()
}
