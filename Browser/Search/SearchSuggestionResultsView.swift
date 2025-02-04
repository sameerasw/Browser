//
//  SearchResultsView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

struct SearchSuggestionResultsView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    var searchManager: SearchManager
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 5) {
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
            .onChange(of: searchManager.highlightedSearchSuggestionIndex) { _, newValue in
                withAnimation(.bouncy) {
                    proxy.scrollTo(newValue, anchor: .bottom)
                }
            }
        }
    }
}
