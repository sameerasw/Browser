//
//  SidebarToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct SidebarToolbar: View {
    
    @EnvironmentObject var preferences: UserPreferences
    
    var body: some View {
        HStack {
            SidebarToolbarButton("sidebar.left", action: preferences.toggleSidebar)
            
            Spacer()
            
            SidebarToolbarButton("arrow.left") {
                print("Go back")
            }
            
            SidebarToolbarButton("arrow.right") {
                print("Go forward")
            }
            
            SidebarToolbarButton("arrow.trianglehead.counterclockwise") {
                print("refresh")
            }
        }
        .buttonStyle(SidebarToolbarButtonStyle())
        .padding(.leading, .approximateTrafficLightsLeadingPadding)
        .padding(.top, .approximateTrafficLightsTopPadding)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SidebarToolbar()
}
