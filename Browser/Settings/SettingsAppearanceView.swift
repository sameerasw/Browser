//
//  SettingsAppearanceView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/7/25.
//

import SwiftUI

struct SettingsAppearanceView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    var body: some View {
        Form {
            Section("App") {
                Toggle("Disable Animations", systemImage: "figure.run", isOn: $userPreferences.disableAnimations)
                
                Picker("Window Background Style", systemImage: "rectangle.fill", selection: $userPreferences.windowBackgroundStyle) {
                    Label("Thin Material", systemImage: "rectangle.fill").tag(UserPreferences.WindowBackgroundStyle.thinMaterial)
                    Label("Liquid Glass", systemImage: "circle.hexagongrid.fill").tag(UserPreferences.WindowBackgroundStyle.liquidGlass)
                }
                
                LoadingPlacePicker()
            }
            
            Section {
                Toggle("Rounded Corners", systemImage: "button.roundedtop.horizontal", isOn: $userPreferences.roundedCorners)
            } header: {
                Text("Web View")
            }
        }
        .formStyle(.grouped)
    }
}
