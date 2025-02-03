//
//  Settings View.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct GeneralSettingsView: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    
    var body: some View {
        Form {
            Section(header: Text("Sidebar Position")) {
                Picker("Sidebar Position", selection: $userPreferences.sidebarPosition) {
                    Text("Leading").tag(UserPreferences.SidebarPosition.leading)
                    Text("Trailing").tag(UserPreferences.SidebarPosition.trailing)
                }
                .pickerStyle(.segmented)
            }
            
            Toggle("Disable Animations", isOn: $userPreferences.disableAnimations)
            Toggle("Test", isOn: $userPreferences.test)
        }
    }
}

#Preview {
    GeneralSettingsView()
}
