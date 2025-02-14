//
//  PageWebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/7/25.
//

import SwiftUI
import SwiftData

/// A view that contains all the stacks for the loaded tabs in all the spaces
struct PageWebView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var userPreferences: UserPreferences
    
    let browserSpaces: [BrowserSpace]
    @Bindable var browserWindowState: BrowserWindowState
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(browserSpaces) { browserSpace in
                    WebView(browserSpace: browserSpace)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
            }
        }
        .scrollPosition(id: $browserWindowState.tabBarScrollState, anchor: .center)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .transaction { $0.disablesAnimations = true }
        // Try to enter Picture in Picture of current tab when tab changes or app goes to background
        .onChange(of: browserWindowState.currentSpace?.currentTab) { oldValue, newValue in
            if userPreferences.openPipOnTabChange {
                if let oldValue {
                    oldValue.webview?.togglePictureInPicture()
                }
                
                if let newValue {
                    newValue.webview?.togglePictureInPicture()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)) { _ in
            if userPreferences.openPipOnTabChange {
                browserWindowState.currentSpace?.currentTab?.webview?.togglePictureInPicture()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)) { _ in
            if userPreferences.openPipOnTabChange {
                browserWindowState.currentSpace?.currentTab?.webview?.togglePictureInPicture()
            }
        }
    }
    
    func enterPiP() {
        
    }
}
