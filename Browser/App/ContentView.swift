//
//  ContentView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

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
