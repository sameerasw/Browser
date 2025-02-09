//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData
import KeyboardShortcuts

struct ContentView: View {
    @StateObject var browserWindowState = BrowserWindowState()
    var body: some View {
        MainFrame()
            .ignoresSafeArea(.container, edges: .top)
            .background(.ultraThinMaterial)
            .focusedSceneValue(\.browserActiveWindowState, browserWindowState)
            .environmentObject(browserWindowState)
            .sheet(isPresented: $browserWindowState.showURLQRCode) {
                URLQRCodeView(browserTab: browserWindowState.currentSpace?.currentTab)
            }
    }
}
