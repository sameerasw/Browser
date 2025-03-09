//
//  WebsiteSearcher.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/8/25.
//

import SwiftUI

/// Protocol to define a website searcher, used to fetch search suggestions directly from a website.
protocol WebsiteSearcher {
    /// The title of the website searcher, example: "Google"
    var title: String { get }
    /// The color of the website searcher, used to display the search suggestions
    var color: Color { get }
    /// The URL to query the search suggestions, example: "https://suggestqueries.google.com/complete/search?client=safari&q="
    func queryURL(for query: String) -> URL
    /// An optional URL to fetch the item, example: "https://www.google.com/search?q="
    func itemURL(for query: String) -> URL
    /// Parses the search suggestions from the string data fetched from the website
    func parseSearchSuggestions(from result: String) throws -> [SearchSuggestion]
}

extension WebsiteSearcher {
    func itemURL(for query: String) -> URL {
        URL(string: "")!
    }
    
    /// General implementation of the search suggestions fetcher.
    func fetchSearchSuggestions(for query: String, in searchManager: SearchManager) {
        searchManager.searchTask?.cancel()
        searchManager.highlightedSearchSuggestionIndex = 0
        
        guard !query.isEmpty else {
            searchManager.searchSuggestions = []
            return
        }
        
        searchManager.searchSuggestions.removeAll()
        searchManager.searchSuggestions.insert(SearchSuggestion(query, itemURL: itemURL(for: query)), at: 0)
                
        searchManager.searchTask = Task {
            do {
                if Task.isCancelled { return }
                let url = queryURL(for: query)
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let resultString = String(data: data, encoding: .utf8) else { return }
                
                searchManager.searchSuggestions.append(contentsOf: try parseSearchSuggestions(from: resultString))
            } catch {
                print("🔍📡 Error fetching search \"\(query)\" suggestions: \(error.localizedDescription)")
            }
        }
    }
}
