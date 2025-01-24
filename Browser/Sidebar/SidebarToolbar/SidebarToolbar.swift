//
//  SidebarToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct SidebarToolbar: View {
    
    @EnvironmentObject var sidebarModel: SidebarModel
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                TrafficLights()
                
                SidebarToolbarButton("sidebar.left", action: sidebarModel.toggleSidebar)
                
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
            .frame(alignment: .top)
            .padding(.top, .approximateTrafficLightsTopPadding)
        }
    }
}

#Preview {
    SidebarToolbar()
}
