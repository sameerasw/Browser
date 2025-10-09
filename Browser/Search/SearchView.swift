//
//  SearchView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

/// View that displays the search view with a text field and search suggestion results
struct SearchView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(BrowserWindowState.self) var browserWindowState
    
    @State var searchManager = SearchManager()
    
    var body: some View {
        VStack(spacing: 0) {
            SearchTextField(searchManager: searchManager)
                .frame(height: 25)
            
            Divider()
                .padding(.top, 5)
            
            SearchSuggestionResultsView(searchManager: searchManager)
        }
        .foregroundStyle(colorScheme == .light ? .black : .white)
        .padding([.horizontal, .top], 15)
        .onKeyPress(.escape) {
            closeSearchView()
            return .handled
        }
        .onKeyPress(.return) {
            searchManager.searchAction(searchManager.searchSuggestions[searchManager.highlightedSearchSuggestionIndex], browserWindowState: browserWindowState, using: modelContext)
            return .handled
        }
        .onKeyPress(.upArrow, action: searchManager.handleUpArrow)
        .onKeyPress(.downArrow, action: searchManager.handleDownArrow)
        .onKeyPress(.tab, action: searchManager.handleTab)
        .onChange(of: searchManager.searchText) { _, newValue in
            if newValue.last != " " {
                searchManager.fetchSearchSuggestions(newValue)
            }
        }
        .onChange(of: browserWindowState.searchOpenLocation) { oldValue, newValue in
            if browserWindowState.searchOpenLocation != .none {
                searchManager.setInitialValuesFromWindowState(browserWindowState)
            }
        }
    }
    
    func closeSearchView() {
        DispatchQueue.main.async {
            browserWindowState.searchOpenLocation = .none
        }
    }
}

#Preview {
    SearchView()
}
