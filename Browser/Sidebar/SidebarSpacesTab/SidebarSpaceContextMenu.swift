//
//  SidebarSpaceContextMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/1/25.
//

import SwiftUI

struct SidebarSpaceContextMenu: View {
    @Bindable var browserSpace: BrowserSpace
    var body: some View {
        Group {
            Button("Print") {
                print("Print")
            }
            
            Divider()
            
            Button("Delete Space") {
                print("Delete")
            }
        }
    }
}
