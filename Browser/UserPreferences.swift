//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

class UserPreferences: ObservableObject {
    enum SidebarPosition: String, CaseIterable {
        case leading
        case trailing
    }
    
    @AppStorage("sidebar_position") var sidebarPosition = SidebarPosition.leading
}
