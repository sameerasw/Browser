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
                Picker("Sidebar Position", systemImage: "sidebar.left", selection: $userPreferences.sidebarPosition) {
                    Label("Leading", systemImage: "sidebar.left").tag(UserPreferences.SidebarPosition.leading)
                    Label("Trailing", systemImage: "sidebar.right").tag(UserPreferences.SidebarPosition.trailing)
                }
                
                Toggle("Disable Animations", systemImage: "figure.run", isOn: $userPreferences.disableAnimations)
                
                Toggle("Show Window Controls On Trailling Sidebar", systemImage: "macwindow", isOn: $userPreferences.showWindowControlsOnTrailingSidebar)
                
                Toggle("Reverse Background Colors on Trailing Sidebar", systemImage: "paintpalette", isOn: $userPreferences.reverseColorsOnTrailingSidebar)
            }
            
            Section {
                Toggle("Rounded Corners", systemImage: "button.roundedtop.horizontal", isOn: $userPreferences.roundedCorners)
                Toggle("Enable Padding", systemImage: "inset.filled.rectangle", isOn: $userPreferences.enablePadding)
                Toggle("Enable Shadow", systemImage: "shadow", isOn: $userPreferences.enableShadow)
            } header: {
                VStack(alignment: .leading) {
                    Text("Web View")
                    Label("Changing these settings will refresh all web views.", systemImage: "exclamationmark.triangle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
    }
}
