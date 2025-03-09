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
    let itemURL: URL
    let favicon: URL?
    
    private var url: URL? {
        URL(string: title.startsWithHTTP ? title : "https://\(title)")
    }
    
    var isURLValid: Bool {
        title.isValidURL
    }
    
    var suggestedURL: URL {
        isURLValid ? url! : itemURL
    }
    
    init(_ title: String, itemURL: URL, favicon: URL? = nil) {
        self.title = title
        self.itemURL = itemURL
        self.favicon = favicon
    }
    
    /// The icon of the search suggestion
    var searchIcon: some View {
        Group {
            if let favicon {
                AsyncImage(url: favicon) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: isURLValid ? "globe" : "magnifyingglass")
                }
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
