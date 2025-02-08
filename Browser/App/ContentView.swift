//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var browserWindowState = BrowserWindowState()
    var body: some View {
        MainFrame()
            .ignoresSafeArea(.container, edges: .top)
            .background(.ultraThinMaterial)
            .environmentObject(browserWindowState)
            .focusedSceneValue(\.browserActiveWindowState, browserWindowState)
    }
}

#Preview {
    ContentView()
}
