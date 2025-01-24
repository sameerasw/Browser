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
    @StateObject var userPreferences = UserPreferences()
    var body: some Scene {
        WindowGroup(id: "BrowserWindow") {
            ContentView()
                .environmentObject(userPreferences)
                .transaction { transaction in
                    if userPreferences.disableAnimations {
                        transaction.animation = nil
                    }
                }
                .frame(minWidth: 400, minHeight: 200)
        }
        .modelContainer(for: [Item.self])
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        
        Settings {
            SettingsView()
                .frame(width: 750, height: 550)
                .environmentObject(userPreferences)
        }
    }
}
