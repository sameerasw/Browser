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
    
    var body: some View {
        ZStack {
            HSplit {
                Sidebar()
            } right: {
                HStack {
                    Button("Toggle Traffic lights") {
                        guard let keyWindow = NSApp.keyWindow else { return }
                        keyWindow.standardWindowButton(.closeButton)?.isHidden.toggle()
                        keyWindow.standardWindowButton(.miniaturizeButton)?.isHidden.toggle()
                        keyWindow.standardWindowButton(.zoomButton)?.isHidden.toggle()
                    }
                    
                    Button("Toggle", action: preferences.toggleSidebar)
                    
                }
            }
            .hide(preferences.sidebarHide)
            .fraction(preferences.sidebarFraction)
            .splitter { Splitter.invisible() }
            .styling(hideSplitter: true)
            .constraints(minPFraction: 0.15, minSFraction: 0.5, priority: .left, dragToHideP: true)
        }
        .padding(5)
        .ignoresSafeArea(.all, edges: .all)
        // Empty toolbar for traffic lights padding
        .toolbar {
            Text("")
        }
    }
}

#Preview {
    ContentView()
}
