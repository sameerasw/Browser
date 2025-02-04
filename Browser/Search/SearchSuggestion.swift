//
//  SearchSuggestion.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

struct SearchSuggestion: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let url: URL?
    let favicon: Data?
    
    init(_ title: String, url: URL? = nil, favicon: Data? = nil) {
        self.title = title
        self.url = url
        self.favicon = favicon
    }
    
    var icon: Image {
        if let favicon = favicon, let image = NSImage(data: favicon) {
            return Image(nsImage: image)
        } else {
            return Image(systemName: "magnifyingglass")
        }
    }
    
    var searchIcon: some View {
        Group {
            if let favicon, let nsImage = NSImage(data: favicon) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "magnifyingglass")
            }
        }
        .frame(width: 15, height: 15)
    }
    
    static func == (lhs: SearchSuggestion, rhs: SearchSuggestion) -> Bool {
        lhs.id == rhs.id
    }
}
