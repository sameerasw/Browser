//
//  BrowserWindowState.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftUI
import SwiftData

/// The BrowserWindowState class is an ObservableObject that holds the current state of the browser window
class BrowserWindowState: ObservableObject {
    
    @Published var currentSpace: BrowserSpace? = nil {
        willSet {
            if let newValue {
                UserDefaults.standard.set(newValue.id.uuidString, forKey: "currentBrowserSpace")
            }
        }
    }
    @Published var viewScrollState: UUID?
    @Published var tabBarScrollState: UUID?
    @Published var searchOpenLocation: SearchOpenLocation? = .none
    
    @Published var showURLQRCode = false
    
    @AppStorage("disable_animations") var disableAnimations = false
        
    /// Loads the current space from the UserDefaults and sets it as the current space
    @Sendable
    func loadCurrentSpace(browserSpaces: [BrowserSpace]) {
        guard let spaceId = UserDefaults.standard.string(forKey: "currentBrowserSpace"),
              let uuid = UUID(uuidString: spaceId) else { return }
        
        if let space = browserSpaces.first(where: { $0.id == uuid }) {
            currentSpace?.currentTab = nil
            goToSpace(space)
        }
    }
    
    func toggleNewTabSearch() {
        if canSpaceOpenNewTab() {
            searchOpenLocation = searchOpenLocation == .fromNewTab ? .none : .fromNewTab
        } else {
            searchOpenLocation = .none
        }
    }
    
    func canSpaceOpenNewTab() -> Bool {
        !(currentSpace == nil || currentSpace?.name.isEmpty == true)
    }
    
    func closeTab(_ browserTab: BrowserTab, modelContext: ModelContext) {
        guard let currentSpace = currentSpace,
                let index = currentSpace.tabs.firstIndex(where: { $0.id == browserTab.id })
        else { return }
        let newTab = currentSpace.tabs[safe: index == 0 ? 1 : index - 1]
        
        browserTab.stopObserving()
        currentSpace.unloadTab(browserTab)
        modelContext.delete(browserTab)
        try? modelContext.save()
        
        withAnimation(disableAnimations ? nil : .bouncy) {
            if let newTab {
                currentSpace.currentTab = newTab
            }
        }
    }
    
    func goToSpace(_ space: BrowserSpace) {
        withAnimation(disableAnimations ? nil : .bouncy) {
            currentSpace = space
            viewScrollState = space.id
            tabBarScrollState = space.id
        }
    }
}
