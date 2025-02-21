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
    
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    @AppStorage("sidebar_position") var sidebarPosition = UserPreferences.SidebarPosition.leading
    
    @State var searchManager = SearchManager()
    
    var body: some View {
        ZStack(alignment: searchManager.searchOpenLocation == .fromURLBar ? sidebarPosition == .leading ? .topLeading : .topTrailing : .center) {
            // Dismiss when tapping outside the search view
            Rectangle()
                .opacity(.leastNonzeroMagnitude)
                .onTapGesture(perform: closeSearchView)
            
            VStack(spacing: 0) {
                SearchTextField(searchManager: searchManager)
                
                Divider()
                    .padding(.top, 5)
                
                SearchSuggestionResultsView(searchManager: searchManager)
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)
            .padding([.horizontal, .top], 15)
            .background(.ultraThickMaterial)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .black.opacity(0.15), radius: 12)
            .macOSWindowBorderOverlay()
            .frame(maxWidth: 650, maxHeight: 305)
            .padding(.top, searchManager.searchOpenLocation == .fromURLBar ? .approximateTrafficLightsTopPadding + 33 : 0)
            .padding(.horizontal, searchManager.searchOpenLocation == .fromURLBar ? .sidebarPadding : 10)
            .onKeyPress(.escape) {
                closeSearchView()
                return .handled
            }
            .onKeyPress(.return) {
                SearchManager.openNewTab(searchManager.searchSuggestions[searchManager.highlightedSearchSuggestionIndex], browserWindowState: browserWindowState, modelContext: modelContext)
                return .handled
            }
            .onKeyPress(.upArrow, action: searchManager.handleUpArrow)
            .onKeyPress(.downArrow, action: searchManager.handleDownArrow)
            .onAppear {
                searchManager.setInitialValuesFromWindowState(browserWindowState)
            }
            .onChange(of: searchManager.searchText) { _, newValue in
                searchManager.fetchSearchSuggestions(newValue)
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
