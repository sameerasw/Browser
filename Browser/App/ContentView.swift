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
    
    @ViewBuilder
    private var mainFrameWithBackground: some View {
        if userPreferences.windowBackgroundStyle == .liquidGlass {
            MainFrame()
                .background(Color.clear.glassEffect(in: .rect(cornerRadius: 10.0)))
        } else {
            MainFrame()
                .background(.thinMaterial)
        }
    }

    var body: some View {
        mainFrameWithBackground
            .ignoresSafeArea(.all)
            .focusedSceneValue(\.browserActiveWindowState, browserWindowState)
            .environment(browserWindowState)
            .sheet(isPresented: $browserWindowState.showURLQRCode) {
                if let currentTab = browserWindowState.currentSpace?.currentTab {
                    URLQRCodeView(browserTab: currentTab)
                }
            }
            .popover(
                isPresented: $browserWindowState.showAcknowledgements,
                attachmentAnchor: .rect(.bounds),
                arrowEdge: .top
            ) {
                Acknowledgments()
                    .environment(browserWindowState)
                    .frame(width: 500, height: 300)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }

    }
}
