//
//  BrowserWindowState.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftUI

class BrowserWindowState: ObservableObject {
    
    @Published var currentTab: BrowserTab? = nil
    
    init() {
        
    }
}
