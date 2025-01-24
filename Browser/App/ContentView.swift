//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            MainFrame()
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

//struct ContentView: View {
//    
//    @EnvironmentObject var preferences: UserPreferences
//    
//    var body: some View {
//        ZStack {
//            HSplit {
//                Sidebar()
//                    .clipped()
//                    .transition(.move(edge: .leading))
//            } right: {
//                WebView()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .clipShape(.rect(cornerRadius: 6))
//                    .padding(6)
//            }
//            .hide(preferences.sidebarHide)
//            .fraction(preferences.sidebarFraction)
//            .splitter { Splitter.invisible() }
//            .styling(invisibleThickness: 20, hideSplitter: true)
//            .constraints(minPFraction: 0.15, minSFraction: 0.5, priority: .left, dragToHideP: true)
//        }
//        .padding(5)
//        .ignoresSafeArea(.all, edges: .all)
//        // Empty toolbar for traffic lights padding
//        .toolbar {
//            Text("")
//        }
//    }
//}

#Preview {
    ContentView()
}
