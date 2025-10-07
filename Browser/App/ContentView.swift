//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var browserWindowState = BrowserWindowState()
    @EnvironmentObject var userPreferences: UserPreferences

    var body: some View {

        MainFrame()
            .background(
                Color.clear
                    .glassEffect(in: .rect(cornerRadius: 28.0))
            )
            .ignoresSafeArea(.container, edges: .top)
            .focusedSceneValue(\.browserActiveWindowState, browserWindowState)
            .environment(browserWindowState)
            .sheet(isPresented: $browserWindowState.showURLQRCode) {
                if let currentTab = browserWindowState.currentSpace?.currentTab {
                    URLQRCodeView(browserTab: currentTab)
                }
            }
            .floatingPanel(isPresented: $browserWindowState.showAcknowledgements, size: CGSize(width: 500, height: 300)) {
                Acknowledgments()
                    .environment(browserWindowState)
            }
    }
}
