//
//  BrowserSpace.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftUI
import SwiftData

/// `BrowserSpace` represents a space in the browser that contains tabs.
@Model
final class BrowserSpace: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var systemImage: String
    var order: Int
    var colors: [String]
    var colorScheme: String
    
    @Relationship(deleteRule: .cascade, inverse: \BrowserTab.browserSpace) var tabs: [BrowserTab]
    
    @Attribute(.ephemeral) var currentTab: BrowserTab? = nil
    @Attribute(.ephemeral) var loadedTabs: [BrowserTab] = []
    
    init(name: String, systemImage: String, order: Int, colors: [Color], colorScheme: String) {
        self.id = UUID()
        self.name = name
        self.systemImage = systemImage
        self.colors = colors.map { $0.hexString() }
        self.order = order
        self.colorScheme = colorScheme
        self.tabs = []
        self.currentTab = nil
    }
    
    /// This is a computed property that returns the colors of the space as `Color` objects
    @Transient var getColors: [Color] {
        colors.map { Color(hex: $0) ?? .clear }
    }
    
    /// Removes a tab from the ZStack of WebViews of the space
    func unloadTab(_ tab: BrowserTab) {
        loadedTabs.removeAll(where: { $0.id == tab.id })
    }
}
