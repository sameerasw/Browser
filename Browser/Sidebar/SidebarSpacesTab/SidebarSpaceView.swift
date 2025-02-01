//
//  SidebarSpaceView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

struct SidebarSpaceView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Bindable var browserSpace: BrowserSpace
    
    var body: some View {
        LazyVStack {
            Label(browserSpace.name, systemImage: browserSpace.systemImage)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            Button("Add Tab", systemImage: "plus") {
                modelContext.insert(BrowserTab(title: "Tab", url: URL(string: "https://www.google.com")!, browserSpace: browserSpace))
                try? modelContext.save()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, .sidebarPadding)
    }
}
