//
//  SearchSuggestion.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

/// A search suggestion that can be displayed in the search suggestions list
struct SearchSuggestion: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let favicon: Data?
    
    var url: URL? {
        URL(string: title.startsWithHTTP ? title : "https://\(title)")
    }
    
    var isURLValid: Bool {
        title.isValidURL
    }
    
    var suggestedURL: URL {
        isURLValid ? url! : URL(string: "https://www.google.com/search?q=\(title)")!
    }
    
    init(_ title: String, favicon: Data? = nil) {
        self.title = title
        self.favicon = favicon
    }
    
    /// The icon of the search suggestion
    var searchIcon: some View {
        Group {
            if let favicon, let nsImage = NSImage(data: favicon) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: isURLValid ? "globe" : "magnifyingglass")
            }
        }
        .frame(width: 15, height: 15)
    }
    
    // MARK: - Equatable
    static func == (lhs: SearchSuggestion, rhs: SearchSuggestion) -> Bool {
        lhs.id == rhs.id
    }
}
