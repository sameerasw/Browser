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

    var searchText = ""
    var searchSuggestions: [SearchSuggestion] = []
    var highlightedSearchSuggestionIndex: Int = 0
    var favicon: Data?

    private var _accentColor = Color.blue
    var accentColor: Color {
        if isUsingWebsiteSearcher {
            return activeWebsiteSearcher.color
        } else {
            return _accentColor
        }
    }

    var matchedWebsiteSearcher: SearchEngine {
        SearchEngine.allCases.first(where: { $0.title.lowercased().hasPrefix(searchText.lowercased()) }) ?? .google
    }
    var isUsingWebsiteSearcher: Bool = false
    var activeWebsiteSearcher = SearchEngine.google.searcher

    var searchTask: URLSessionDataTask?

    /// Sets the initial values from the `BrowserWindowState`
    /// - Parameter browserWindowState: The `BrowserWindowState` to get the initial values from
    func setInitialValuesFromWindowState(_ browserWindowState: BrowserWindowState) {
        if let accentColor = Color(hex: browserWindowState.currentSpace?.colors.first ?? "") {
            self._accentColor = accentColor
        }

        if browserWindowState.searchOpenLocation == .fromURLBar {
            searchText = browserWindowState.currentSpace?.currentTab?.url.absoluteString ?? ""
            favicon = browserWindowState.currentSpace?.currentTab?.favicon
        }
    }

    /// Handles the search action
    /// - Parameters: searchText: The autocomplete text to search
    func fetchSearchSuggestions(_ searchText: String) {
        activeWebsiteSearcher.fetchSearchSuggestions(for: searchText, in: self)
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

    /// Handle the tab key press, switches the search engine
    func handleTab() -> KeyPress.Result {
        withAnimation(.browserDefault) {
            if isUsingWebsiteSearcher {
                resetWebsiteSearcher()
            } else if matchedWebsiteSearcher != .google {
                isUsingWebsiteSearcher = true
                activeWebsiteSearcher = matchedWebsiteSearcher.searcher
                searchText = ""
            }
        }

        return .handled
    }

    /// Open a new tab with the selected search suggestion
    /// - Parameters: searchSuggestion: The selected search suggestion
    /// - Parameters: browserWindowState: The current `BrowserWindowState`
    /// - Parameters: modelContext: The current `ModelContext`
    private func openNewTab(_ searchSuggestion: SearchSuggestion, browserWindowState: BrowserWindowState, using modelContext: ModelContext) {
        let newTab = BrowserTab(
            title: searchSuggestion.title,
            favicon: nil,
            url: searchSuggestion.suggestedURL,
            order: (browserWindowState.currentSpace?.tabs.count ?? 0),
            browserSpace: browserWindowState.currentSpace
        )

        do {
            browserWindowState.currentSpace?.tabs.append(newTab)
            try modelContext.save()
        } catch {
            print("Error opening new tab: \(error)")
        }

        browserWindowState.currentSpace?.currentTab = newTab
    }

    /// Opens the search suggestion in the current tab
    /// - Parameters: searchSuggestion: The selected search suggestion
    /// - Parameters: browserWindowState: The current `BrowserWindowState`
    /// - Parameters: modelContext: The current `ModelContext`
    private func openInCurrentTab(_ searchSuggestion: SearchSuggestion, browserWindowState: BrowserWindowState, using modelContext: ModelContext) {
        if let currentTab = browserWindowState.currentSpace?.currentTab {
            currentTab.url = searchSuggestion.suggestedURL
            currentTab.webview?.load(URLRequest(url: searchSuggestion.suggestedURL))
            currentTab.updateFavicon(with: searchSuggestion.suggestedURL)
        } else {
            openNewTab(searchSuggestion, browserWindowState: browserWindowState, using: modelContext)
        }
    }

    func searchAction(_ searchSuggestion: SearchSuggestion, browserWindowState: BrowserWindowState, using modelContext: ModelContext) {
        if browserWindowState.searchOpenLocation == .fromNewTab {
            openNewTab(searchSuggestion, browserWindowState: browserWindowState, using: modelContext)
        } else {
            openInCurrentTab(searchSuggestion, browserWindowState: browserWindowState, using: modelContext)
        }

        // Closes the search bar
        DispatchQueue.main.async {
            browserWindowState.searchOpenLocation = .none
        }
    }

    func resetWebsiteSearcher() {
        isUsingWebsiteSearcher = false
        activeWebsiteSearcher = SearchEngine.google.searcher
    }
}
