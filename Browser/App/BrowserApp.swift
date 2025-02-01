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
    
    let modelContainer: ModelContainer
    init() {
        do {
            modelContainer = try ModelContainer(
                for: BrowserSpace.self, BrowserTab.self,
                migrationPlan: BrowserSchemasMigrationPlan.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup(id: "BrowserWindow") {
            ContentView()
                .environmentObject(UserPreferences())
                .environmentObject(BrowserWindowState())
                .transaction { transaction in
                    if userPreferences.disableAnimations {
                        transaction.animation = nil
                    }
                }
                .frame(minWidth: 400, minHeight: 200)
        }
        .modelContainer(modelContainer)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        
        Settings {
            SettingsView()
                .frame(width: 750, height: 550)
                .environmentObject(userPreferences)
        }
    }
}
