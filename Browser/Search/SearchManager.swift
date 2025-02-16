//
//  SearchManager.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI
import SwiftData

/// `SearchManager` manages the search action and search suggestions
@Observable
class SearchManager {
    
    var searchOpenLocation: SearchOpenLocation?
    var searchText = ""
    var currentTab: BrowserTab?
    var searchSuggestions: [SearchSuggestion] = []
    var highlightedSearchSuggestionIndex: Int = 0
    var favicon: Data?
    var accentColor = AnyShapeStyle(.blue.gradient)
    
    private var searchTask: Task<Void, Never>?
    
    /// Sets the initial values from the `BrowserWindowState`
    /// - Parameter browserWindowState: The `BrowserWindowState` to get the initial values from
    func setInitialValuesFromWindowState(_ browserWindowState: BrowserWindowState) {
        searchOpenLocation = browserWindowState.searchOpenLocation
        
        if let accentColor = Color(hex: browserWindowState.currentSpace?.colors.first ?? "") {
            self.accentColor = AnyShapeStyle(accentColor)
        }
        
        if searchOpenLocation == .fromURLBar {
            currentTab = browserWindowState.currentSpace?.currentTab
            searchText = browserWindowState.currentSpace?.currentTab?.url.absoluteString ?? ""
            favicon = browserWindowState.currentSpace?.currentTab?.favicon
        }
    }
    
    /// Handles the search action
    /// - Parameters: searchText: The autocomplete text to search
    func fetchSearchSuggestions(_ searchText: String) {
        searchTask?.cancel()
        // Reset the highlighted search suggestion
        highlightedSearchSuggestionIndex = 0
        
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchSuggestions = []
            return
        }
        
        if !searchSuggestions.isEmpty {
            searchSuggestions.remove(at: 0)
        }
        
        searchSuggestions.insert(SearchSuggestion(searchText), at: 0)
        
        searchTask = Task {
            do {
                if Task.isCancelled { return }
                let url = URL(string: "https://suggestqueries.google.com/complete/search?client=safari&q=\(searchText)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                parseSearchSuggestions(from: data)
            } catch {
                print("🔍📡 Error fetching search \"\(searchText)\" suggestions: \(error.localizedDescription)")
            }
        }
    }
    
    /// Parses the search suggestions from the data
    private func parseSearchSuggestions(from data: Data) {
        guard let string = String(data: data, encoding: .isoLatin1) else {
            return print("🔍👓 Error parsing search suggestions. Invalid string data. \"\(searchText)\". \(data)")
        }
    
        let components = string.components(separatedBy: ",")
        guard !components.isEmpty else {
            return print("🔍👓 Error parsing search suggestions. Empty components. \"\(searchText)\". \(data)")
        }
        
        let regex = try! NSRegularExpression(pattern: #""(.*?)""#)
        
        let extractedStrings = components.flatMap { string -> [String] in
            let matches = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
            return matches.compactMap { match -> String? in
                if let range = Range(match.range(at: 1), in: string) {
                    var extracted = String(string[range])
                    // Process Unicode characters
                    extracted = extracted.applyingTransform(StringTransform("Hex-Any"), reverse: false) ?? extracted
                    // Don't include empty strings
                    return extracted.isEmpty ? nil : extracted
                }
                return nil
            }
        }
        
        // Drop first suggestion because it's the same as the search text
        // Drop last 3 suggestions because they are not search suggestions
        searchSuggestions = [SearchSuggestion(searchText)] + extractedStrings.dropLast(3).dropFirst().map {
            SearchSuggestion($0)
        }
    }
    
    /// Move the highlighted search suggestion index up
    func handleUpArrow() -> KeyPress.Result {
        guard !searchSuggestions.isEmpty else { return .ignored }
        
        if highlightedSearchSuggestionIndex > 0 {
            highlightedSearchSuggestionIndex -= 1
        } else {
            highlightedSearchSuggestionIndex = searchSuggestions.count - 1
        }
        return .handled
    }
    
    /// Move the highlighted search suggestion index down
    func handleDownArrow() -> KeyPress.Result {
        guard !searchSuggestions.isEmpty else { return .ignored }
        
        if highlightedSearchSuggestionIndex < searchSuggestions.count - 1 {
            highlightedSearchSuggestionIndex += 1
        } else {
            highlightedSearchSuggestionIndex = 0
        }
        return .handled
    }
    
    /// Open a new tab with the selected search suggestion
    /// - Parameters: searchSuggestion: The selected search suggestion
    /// - Parameters: browserWindowState: The current `BrowserWindowState`
    /// - Parameters: modelContext: The current `ModelContext`
    func openNewTab(_ searchSuggestion: SearchSuggestion, browserWindowState: BrowserWindowState, modelContext: ModelContext) {
        let url = searchSuggestion.isURLValid ? searchSuggestion.url! : URL(string: "https://www.google.com/search?q=\(searchSuggestion.title)")!
        let newTab = BrowserTab(title: searchSuggestion.title, url: url, order: 0, browserSpace: browserWindowState.currentSpace)
        
        do {
            browserWindowState.currentSpace?.tabs.append(newTab)
            try modelContext.save()
        } catch {
            print("Error opening new tab: \(error)")
        }
        
        
        browserWindowState.currentSpace?.currentTab = newTab
        // Closes the search bar
        DispatchQueue.main.async {
            browserWindowState.searchOpenLocation = .none
        }
    }
}
