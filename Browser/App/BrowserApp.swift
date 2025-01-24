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
        WindowGroup {
            ContentView()
                .environmentObject(userPreferences)
        }
        .modelContainer(for: [Item.self])
        .windowStyle(.hiddenTitleBar)
        
        Settings {
            SettingsView()
                .frame(width: 750, height: 550)
                .environmentObject(userPreferences)
        }
    }
}
