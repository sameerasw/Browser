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
    @Environment(BrowserWindowState.self) var browserWindowState

    @EnvironmentObject var userPreferences: UserPreferences

    let browserSpaces: [BrowserSpace]

    // UUID to scroll to the current space (using browserWindowState.viewScrollState doesn't work)
    @State var scrollState: UUID?

    var body: some View {
        VStack(spacing: 0) {
            if userPreferences.urlBarPosition == .onToolbar {
                SidebarURLToolbar()
            }

            ScrollView(.horizontal) {
                LazyHStack(spacing: .zero) {
                    ForEach(browserSpaces) { browserSpace in
                        WebViewStack(browserSpace: browserSpace)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollPosition(id: $scrollState, anchor: .center)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .onChange(of: browserWindowState.currentSpace) { _, newValue in
            scrollState = newValue?.id
            // Trigger strong haptic feedback for space changes
            HapticFeedback.shared.performAlignment()
        }
        .animation(.easeInOut(duration: 0.3), value: scrollState)
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
}
