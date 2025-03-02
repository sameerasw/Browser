//
//  SearchTextField.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

/// Search text field that shows the favicon of the search engine
struct SearchTextField: View {
    
    @Environment(BrowserWindowState.self) var browserWindowState
    
    /// Enum to focus the search text field when it appears
    enum FocusedField {
        case search
        case unfocused
    }
    
    @Bindable var searchManager: SearchManager
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        HStack {
            searchIcon
                .padding(.leading, 5)
            
            TextField("Where to?", text: $searchManager.searchText)
                .focused($focusedField, equals: .search)
                .textFieldStyle(.plain)
                .font(browserWindowState.searchOpenLocation == .fromNewTab ? .title2.weight(.semibold) : .body)
        }
        .onChange(of: browserWindowState.searchOpenLocation) { _, newValue in
            focusedField = newValue != .none ? .search : .unfocused
            if newValue == .fromURLBar {
                DispatchQueue.main.async {
                    NSApplication.shared.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: nil)
                }
            } else {
                searchManager.searchText = ""
            }
        }
    }
    
    var searchIcon: some View {
        Group {
            if let favicon = searchManager.favicon, let nsImage = NSImage(data: favicon) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "magnifyingglass")
            }
        }
        .frame(width: 15, height: 15)
    }
}
