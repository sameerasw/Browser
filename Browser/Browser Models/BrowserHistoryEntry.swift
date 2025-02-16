//
//  BrowserHistoryEntry.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/15/25.
//

import SwiftData

/// An immutable model that represents a browser history entry.
@Model
final class BrowserHistoryEntry: Identifiable {
    private(set) var id: UUID
    private(set) var title: String
    private(set) var url: URL
    private(set) var favicon: Data?
    private(set) var date: Date
    
    init(id: UUID = UUID(), title: String, url: URL, favicon: Data?, date: Date = .now) {
        self.id = id
        self.title = title
        self.url = url
        self.favicon = favicon
        self.date = date
    }
}
