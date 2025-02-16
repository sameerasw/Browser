//
//  BrowserWindowState.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftUI
import SwiftData

/// The BrowserWindowState is an Observable class that holds the current state of the browser window
@Observable class BrowserWindowState {
    
    var currentSpace: BrowserSpace? = nil {
        willSet {
            if let newValue {
                UserDefaults.standard.set(newValue.id.uuidString, forKey: "currentBrowserSpace")
            }
        }
    }
    var viewScrollState: UUID?
    var tabBarScrollState: UUID?
    var searchOpenLocation: SearchOpenLocation? = .none
    
    var showURLQRCode = false
    
    var actionAlertMessage = ""
    var actionAlertSystemImage = ""
    var showActionAlert = false
            
    /// Loads the current space from the UserDefaults and sets it as the current space
    @Sendable
    func loadCurrentSpace(browserSpaces: [BrowserSpace]) {
        guard let spaceId = UserDefaults.standard.string(forKey: "currentBrowserSpace"),
              let uuid = UUID(uuidString: spaceId) else { return }
        
        if let space = browserSpaces.first(where: { $0.id == uuid }) {
            currentSpace?.currentTab = nil
            currentSpace?.loadedTabs.removeAll()
            goToSpace(space)
        }
    }
    
    /// Toggles the search open location between the URL bar and the new tab
    func toggleNewTabSearch() {
        if canSpaceOpenNewTab() {
            searchOpenLocation = searchOpenLocation == .fromNewTab ? .none : .fromNewTab
        } else {
            searchOpenLocation = .none
        }
    }
    
    /// Checks if the current space can open a new tab
    func canSpaceOpenNewTab() -> Bool {
        !(currentSpace == nil || currentSpace?.name.isEmpty == true)
    }
    
    /// Goes to a space in the browser
    func goToSpace(_ space: BrowserSpace) {
        withAnimation(.browserDefault) {
            currentSpace = space
            viewScrollState = space.id
            tabBarScrollState = space.id
        }
    }
    
    /// Copies the URL of the current tab to the clipboard
    func copyURLToClipboard() {
        if let url = currentSpace?.currentTab?.url.absoluteString {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(url, forType: .string)
            presentActionAlert(message: "Copied Current URL", systemImage: "link")
        }
    }
    
    /// Presents an action alert with a message and a system image
    func presentActionAlert(message: String, systemImage: String) {
        actionAlertMessage = message
        actionAlertSystemImage = systemImage
        withAnimation(.browserDefault) {
            showActionAlert = true
        }
    }
}
