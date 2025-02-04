//
//  SearchTextField.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/3/25.
//

import SwiftUI

struct SearchTextField: View {
    
    enum FocusedField {
        case search
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
                .font(searchManager.searchOpenLocation == .fromNewTab ? .title2.weight(.semibold) : .body)
        }
        .onAppear {
            focusedField = .search
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
