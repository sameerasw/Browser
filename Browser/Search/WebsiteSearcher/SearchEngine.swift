//
//  SearchEngine.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/8/25.
//

import Foundation

enum SearchEngine: CaseIterable {
    case google
    
    /// The search engine to use
    var searcher: WebsiteSearcher {
        switch self {
        case .google: GoogleSearcher()
        }
    }
    
    /// The title of the search engine
    var title: String {
        self.searcher.title
    }
}

extension SearchEngine {
    /// All search engines available
    static var allSearchers: [WebsiteSearcher] {
        SearchEngine.allCases.map { $0.searcher }
    }
}
