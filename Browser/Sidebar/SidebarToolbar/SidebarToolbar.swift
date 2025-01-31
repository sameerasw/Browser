//
//  SidebarToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct SidebarToolbar: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var sidebarModel: SidebarModel
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                if userPreferences.sidebarPosition == .leading {
                    TrafficLights()
                }
                
                SidebarToolbarButton(userPreferences.sidebarPosition == .leading ? "sidebar.left" : "sidebar.right", action: sidebarModel.toggleSidebar)
                    .padding(.leading, userPreferences.sidebarPosition == .trailing ? 5 : 0)
                
                Spacer()
                
                SidebarToolbarButton("arrow.left") {
                    print("Go back")
                }
                
                SidebarToolbarButton("arrow.right") {
                    print("Go forward")
                }
                
                SidebarToolbarButton("arrow.trianglehead.clockwise") {
                    print("refresh")
                }
            }
            .frame(alignment: .top)
            .padding(.top, .approximateTrafficLightsTopPadding)
            .padding(.trailing, .sidebarPadding)
        }
    }
}

#Preview {
    SidebarToolbar()
}
