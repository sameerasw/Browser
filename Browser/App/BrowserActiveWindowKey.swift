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

extension FocusedValues {
    var browserActiveWindowState: BrowserWindowState? {
        get { self[BrowserActiveWindowKey.self] }
        set { self[BrowserActiveWindowKey.self] = newValue }
    }
}
