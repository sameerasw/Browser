//
//  BrowserActiveWindowKey.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/8/25.
//

import SwiftUI

/// Key to store the active window state
struct BrowserActiveWindowKey: FocusedValueKey {
    typealias Value = BrowserWindowState
}

struct SidebarModelActiveWindowKey: FocusedValueKey {
    typealias Value = SidebarModel
}

struct SplitViewStateKey: FocusedValueKey {
    typealias Value = SplitViewState
}

struct UserPreferencesKey: FocusedValueKey {
    typealias Value = UserPreferences
}

extension FocusedValues {
    var browserActiveWindowState: BrowserWindowState? {
        get { self[BrowserActiveWindowKey.self] }
        set { self[BrowserActiveWindowKey.self] = newValue }
    }
    
    var sidebarModel: SidebarModel? {
        get { self[SidebarModelActiveWindowKey.self] }
        set { self[SidebarModelActiveWindowKey.self] = newValue }
    }
    
    var splitViewState: SplitViewState? {
        get { self[SplitViewStateKey.self] }
        set { self[SplitViewStateKey.self] = newValue }
    }
    
    var userPreferences: UserPreferences? {
        get { self[UserPreferencesKey.self] }
        set { self[UserPreferencesKey.self] = newValue }
    }
}
