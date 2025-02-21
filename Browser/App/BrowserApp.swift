//
//  BrowserApp.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

@main
struct BrowserApp: App {
    
    @NSApplicationDelegateAdaptor(BrowserAppDelegate.self) var appDelegate
        
    var body: some Scene {
        BrowserWindow("BrowserWindow")
        BrowserWindow("BrowserTemporaryWindow", inMemory: true)
        
        SettingsWindow()
    }
    
    @SceneBuilder
    func BrowserWindow(_ id: String, inMemory: Bool = false) -> some Scene {
        WindowGroup(id: id) {
            ContentView()
                .environmentObject(appDelegate.userPreferences)
                .transaction {
                    $0.disablesAnimations = appDelegate.userPreferences.disableAnimations
                }
                .frame(minWidth: 400, minHeight: 200)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            BrowserCommands()
        }
        .modelContainer(for: [BrowserSpace.self, BrowserTab.self, BrowserHistoryEntry.self], inMemory: inMemory)
    }
    
    @SceneBuilder
    func SettingsWindow() -> some Scene {
        Settings {
            SettingsView()
                .frame(width: 750, height: 550)
                .environmentObject(appDelegate.userPreferences)
        }
    }
}
