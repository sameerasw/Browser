//
//  BrowserSpace.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftUI
import SwiftData

typealias BrowserSpace = BrowserSchemaV001.BrowserSpace

extension BrowserSchemaV001 {
    @Model
    final class BrowserSpace: Identifiable {
        
        @Attribute(.unique) var id: UUID
        var name: String
        var systemImage: String
        var colors: [String]
        var colorScheme: String
        
        @Relationship(deleteRule: .cascade) var tabs: [BrowserTab]
        
        @Transient var currentTab: BrowserTab?
        
        init(name: String, systemImage: String, colors: [Color], colorScheme: String) {
            self.id = UUID()
            self.name = name
            self.systemImage = systemImage
            self.colors = colors.map { $0.hexString() }
            self.colorScheme = colorScheme
            self.tabs = []
        }
        
        @Transient var getColors: [Color] {
            colors.map { Color(hex: $0) ?? .clear }
        }
    }
}
