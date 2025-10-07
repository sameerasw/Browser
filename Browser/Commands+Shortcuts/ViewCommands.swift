//
//  ViewCommands.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/9/25.
//

import SwiftUI
import KeyboardShortcuts

struct ViewCommands: Commands {

    @FocusedValue(\.browserActiveWindowState) var browserWindowState
    @FocusedValue(\.sidebarModel) var sidebarModel
    @FocusedValue(\.splitViewState) var splitViewState

    var body: some Commands {
        CommandGroup(replacing: .toolbar) {
            Button("Toggle Sidebar") {
                if let splitViewState = splitViewState {
                    splitViewState.columnVisibility = (splitViewState.columnVisibility == .all ? .detailOnly : .all)
                }
            }
                .globalKeyboardShortcut(.toggleSidebar)

            Divider()
            
            Button("Rescan Styles") {
                StyleManager.shared.scanStyles()
                // Reapply styles to current tab if transparency is enabled
                if let tab = browserWindowState?.currentSpace?.currentTab,
                   let webView = tab.webview,
                   let viewController = tab.viewController {
                    viewController.applyTransparency()
                }
            }

            Divider()

            Button("Show Tab Switcher") {
                browserWindowState?.showTabSwitcher = true
            }
            .globalKeyboardShortcut(.showTabSwitcher)

            Divider()

            if let tab = browserWindowState?.currentSpace?.currentTab, let webView = tab.webview {
                Button("Stop Loading") { webView.stopLoading() }
                    .globalKeyboardShortcut(.stopLoading)
                    .disabled(!webView.isLoading)
                Button("Reload This Page") {
                    tab.clearError()
                    webView.reload()
                }
                .globalKeyboardShortcut(.reload)
                Button("Clear Cookies And Reload") {
                    tab.clearError()
                    webView.clearCookiesAndReload()
                }
                .globalKeyboardShortcut(.clearCookiesAndReload)
                Button("Clear Cache And Reload") {
                    tab.clearError()
                    webView.clearCacheAndReload()
                }
                .globalKeyboardShortcut(.clearCacheAndReload)

                Divider()

                Button("Toggle Picture In Picture", action: webView.togglePictureInPicture)
                    .globalKeyboardShortcut(.togglePictureInPicture)

                Divider()

                Button("Zoom Actual Size", action: webView.zoomActualSize)
                    .globalKeyboardShortcut(.zoomActualSize)
                Button("Zoom In", action: webView.zoomIn)
                    .keyboardShortcut("+", modifiers: .command)
                Button("Zoom Out", action: webView.zoomOut)
                    .globalKeyboardShortcut(.zoomOut)

            }
        }
    }
}

extension KeyboardShortcuts.Name {
    static let toggleSidebar = Self("toggle_sidebar", default: .init(.s, modifiers: .command))

    static let showTabSwitcher = Self("show_tab_switcher", default: .init(.tab, modifiers: .control))

    static let stopLoading = Self("stop_loading", default: .init(.period, modifiers: .command))
    static let reload = Self("reload", default: .init(.r, modifiers: .command))
    static let clearCookiesAndReload = Self("clear_cookies_and_reload")
    static let clearCacheAndReload = Self("clear_cache_and_reload")

    static let togglePictureInPicture = Self("toggle_picture_in_picture")

    static let zoomActualSize = Self("zoom_actual_size", default: .init(.zero, modifiers: .command))
    static let zoomIn = Self("zoom_in", default: .init(.equal, modifiers: .command))
    static let zoomOut = Self("zoom_out", default: .init(.minus, modifiers: .command))

}

extension [KeyboardShortcuts.Name] {
    static let allViewCommands: [KeyboardShortcuts.Name] = [.toggleSidebar, .showTabSwitcher, .stopLoading, .reload, .clearCookiesAndReload, .clearCacheAndReload, .togglePictureInPicture, .zoomActualSize, .zoomIn, .zoomOut]
}
