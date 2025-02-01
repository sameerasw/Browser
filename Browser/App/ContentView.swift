//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            MainFrame()
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ContentView()
}
