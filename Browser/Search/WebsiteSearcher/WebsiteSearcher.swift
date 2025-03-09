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
    /// The URL to query the search suggestions, example: "https://suggestqueries.google.com/complete/search?client=safari&q="
    func queryURL(for query: String) -> URL
    /// The color of the website searcher, used to display the search suggestions
    var color: Color { get }
    /// Parses the search suggestions from the string data fetched from the website
    func parseSearchSuggestions(from result: String) throws -> [SearchSuggestion]
}

extension WebsiteSearcher {
    /// General implementation of the search suggestions fetcher.
    func fetchSearchSuggestions(for query: String, in searchManager: SearchManager) {
        searchManager.searchTask?.cancel()
        searchManager.highlightedSearchSuggestionIndex = 0
        
        guard !query.isEmpty else {
            searchManager.searchSuggestions = []
            return
        }
        
        if !searchManager.searchSuggestions.isEmpty {
            searchManager.searchSuggestions.remove(at: 0)
        }
        
        searchManager.searchSuggestions.insert(SearchSuggestion(query), at: 0)
                
        searchManager.searchTask = Task {
            do {
                if Task.isCancelled { return }
                let url = queryURL(for: query)
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let resultString = String(data: data, encoding: .utf8) else { return }
                
                searchManager.searchSuggestions = try [SearchSuggestion(query)] + parseSearchSuggestions(from: resultString)
                
                // Remove the second search suggestion if it's not a valid URL
                // This means that this search suggestion is the same as the search query
                if searchManager.searchSuggestions.count > 1 {
                    if !searchManager.searchSuggestions[1].isURLValid {
                        searchManager.searchSuggestions.remove(at: 1)
                    }
                }
            } catch {
                print("🔍📡 Error fetching search \"\(query)\" suggestions: \(error.localizedDescription)")
            }
        }
    }
}
