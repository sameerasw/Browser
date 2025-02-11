//
//  SearchResultsView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

/// View that displays the search suggestions
struct SearchSuggestionResultsView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    var searchManager: SearchManager
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 5) {
                    // Based on index for the highlighted search suggestion
                    ForEach(Array(zip(searchManager.searchSuggestions.indices, searchManager.searchSuggestions)), id: \.0) { index, searchSuggestion in
                        SearchSuggestionResultItem(searchManager: searchManager, index: index, searchSuggestion: searchSuggestion)
                            .id(index)
                            .onTapGesture {
                                searchManager.openNewTab(searchSuggestion, browserWindowState: browserWindowState, modelContext: modelContext)
                            }
                    }
                }
                .padding(.vertical, 5)
            }
            .scrollIndicators(.never)
            // Scroll to the highlighted search suggestion
            .onChange(of: searchManager.highlightedSearchSuggestionIndex) { _, newValue in
                withAnimation(.browserDefault) {
                    proxy.scrollTo(newValue, anchor: .bottom)
                }
            }
        }
    }
}
