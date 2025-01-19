//
//  Sidebar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text("Sidebar")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
    }
}

#Preview {
    Sidebar()
}
