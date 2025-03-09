//
//  BingSearcher.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/8/25.
//

import SwiftUI

/// Searcher for Bing
struct BingSearcher: WebsiteSearcher {
    var title = "Bing"
        
    func queryURL(for query: String) -> URL {
        URL(string: "https://www.bing.com/asjson.aspx?query=\(query)")!
    }
    
    var color = Color(hex: "02B7E9")!
    
    func parseSearchSuggestions(from result: String) throws -> [SearchSuggestion] {
        []
    }
}
