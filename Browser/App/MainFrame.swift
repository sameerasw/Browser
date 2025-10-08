//
//  MainFrame.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI
import SwiftData

/// Main frame of the browser.
struct MainFrame: View {

    @Environment(BrowserWindowState.self) var browserWindowState
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var userPreferences: UserPreferences
    @StateObject private var splitState = SplitViewState()

    @State var sidebarModel = SidebarModel()

    @Query(sort: \BrowserSpace.order) var browserSpaces: [BrowserSpace]

    var isImmersive: Bool {
        browserWindowState.isFullScreen && sidebarModel.sidebarCollapsed && userPreferences.immersiveViewOnFullscreen
    }

    var body: some View {
        @Bindable var browserWindowState = browserWindowState

        NavigationSplitView(columnVisibility: $splitState.columnVisibility) {
            sidebarView
        } detail: {
            pageView
        }
        .animation(.easeInOut(duration: 0.3), value: splitState.columnVisibility)

        .onChange(of: splitState.columnVisibility) { oldValue, newValue in
            NSApp.setBrowserWindowControls(hidden: newValue == .detailOnly)
        }

        .frame(maxWidth: .infinity)
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        .background {
            if let currentSpace = browserWindowState.currentSpace {
                SidebarSpaceBackground(browserSpace: currentSpace, isSidebarCollapsed: false)
            }
        }
        // Show the search view
        .floatingPanel(isPresented: .init(get: {
            browserWindowState.searchOpenLocation != .none
        }, set: { newValue in
            if !newValue {
                browserWindowState.searchOpenLocation = .none
            }
        }), origin: browserWindowState.searchPanelOrigin, size: browserWindowState.searchPanelSize, shouldCenter: browserWindowState.searchOpenLocation == .fromNewTab || userPreferences.urlBarPosition == .onToolbar) {
            SearchView()
                .environment(browserWindowState)
        }
        // Show the tab switcher
        .floatingPanel(isPresented: $browserWindowState.showTabSwitcher, size: CGSize(width: 700, height: 200)) {
            TabSwitcher(browserSpaces: browserSpaces)
                .environment(browserWindowState)
        }
        .transaction {
            if userPreferences.disableAnimations {
                $0.animation = nil
            }
        }
        .environment(sidebarModel)
        .focusedSceneValue(\.sidebarModel, sidebarModel)
        .environmentObject(splitState)
        .focusedSceneValue(\.splitViewState, splitState)
        .focusedSceneValue(\.userPreferences, userPreferences)
        .foregroundStyle(browserWindowState.currentSpace?.textColor(in: colorScheme) ?? .primary)
        .ignoresSafeArea(.all)
    }

    var sidebar: some View {
        Sidebar(browserSpaces: browserSpaces)
            .frame(width: sidebarModel.currentSidebarWidth)
            .readingWidth(width: $sidebarModel.currentSidebarWidth)
    }

    // MARK: - Sidebar
    @ViewBuilder
    private var sidebarView: some View {
        Sidebar(browserSpaces: browserSpaces)
            .padding(8)
            .padding(.top, 24)
            .ignoresSafeArea(.all)
            .modifier(ConditionalToolbarRemover(shouldRemove: splitState.columnVisibility == .detailOnly))
    }

    // MARK: - Detail (WebView)
    @ViewBuilder
    private var pageView: some View {
        PageWebView(browserSpaces: browserSpaces)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .shadow(radius: shadowRadius)
            .ignoresSafeArea(edges: userPreferences.extendedSidebarStyle ? .all : [.top, .bottom, .trailing])
            .animation(.easeInOut(duration: 0.3), value: userPreferences.extendedSidebarStyle)
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.willEnterFullScreenNotification)) { _ in
                withAnimation(.browserDefault) {
                    browserWindowState.isFullScreen = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.willExitFullScreenNotification)) { _ in
                withAnimation(.browserDefault) {
                    browserWindowState.isFullScreen = false
                }
            }
            .actionAlert()
    }

    // MARK: - Computed properties
    private var cornerRadius: CGFloat {
        isImmersive ? 0 : (userPreferences.roundedCorners ? 8 : 0)
    }

    private var shadowRadius: CGFloat {
        isImmersive ? 0 : (userPreferences.enableShadow ? 3 : 0)
    }

}

struct ConditionalToolbarRemover: ViewModifier {
    let shouldRemove: Bool
    @Environment(BrowserWindowState.self) var browserWindowState

    func body(content: Content) -> some View {
        if shouldRemove {
            content.toolbar(removing: .sidebarToggle)
        } else {
            content.toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        browserWindowState.backButtonAction()
                    } label: {
                        Label("Back", systemImage: "arrow.left")
                    }
                    .help("Go back")

                    Button {
                        browserWindowState.forwardButtonAction()
                    } label: {
                        Label("Forward", systemImage: "arrow.right")
                    }
                    .help("Go forward")

                    Button {
                        browserWindowState.refreshButtonAction()
                    } label: {
                        Label("Reload", systemImage: "arrow.trianglehead.clockwise")
                    }
                    .help("Reload")
                }
            }
        }
    }
}
