//
//  BrowserCustomSearcher.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/9/25.
//

import SwiftData

/// A custom website searcher that the user can add
struct BrowserCustomSearcher: Identifiable, Codable {
    var id = UUID().uuidString
    /// The name of the website to search, e.g. "Google"
    var website: String
    /// The query URL for the website, e.g. "https://www.google.com/search?q="
    var queryURL: String
}
