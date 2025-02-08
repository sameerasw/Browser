//
//  PageWebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/7/25.
//

import SwiftUI
import SwiftData

/// A view that contains all the stacks for the loaded tabs in all the spaces
struct PageWebView: View {
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    @Query(sort: \BrowserSpace.order) var browserSpaces: [BrowserSpace]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(browserSpaces) { browserSpace in
                    WebView(browserSpace: browserSpace)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
            }
        }
        .scrollPosition(id: $browserWindowState.tabBarScrollState, anchor: .center)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .transaction { $0.disablesAnimations = true }
    }
}
