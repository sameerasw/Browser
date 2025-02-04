//
//  SidebarSpacesTabView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI
import SwiftData

/// Horizontal scrollable collection of spaces in the sidebar
struct SidebarSpacesTabView: View {
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    let browserSpaces: [BrowserSpace]
    
    @State var appeared = false
    @State var lastWidth = CGFloat.zero
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(browserSpaces) { browserSpace in
                    SidebarSpaceView(browserSpaces: browserSpaces, browserSpace: browserSpace)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $browserWindowState.viewScrollState, anchor: .center)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        // Scroll to the selected space when the viewScrollState changes
        .onChange(of: browserWindowState.viewScrollState) { oldValue, newValue in
            if let newValue {
                withAnimation(appeared ? .bouncy : nil) {
                    browserWindowState.tabBarScrollState = newValue
                    browserWindowState.currentSpace = browserSpaces.first { $0.id == newValue }
                }
            }
        }
        // This is a workaround to prevent the animation when the view first appears
        .transaction { transaction in
            if !appeared {
                transaction.animation = nil
            }
        }
        .onAppear {
            if browserWindowState.currentSpace == nil {
                browserWindowState.loadCurrentSpace(browserSpaces: browserSpaces)
            }
            
            browserWindowState.viewScrollState = browserWindowState.currentSpace?.id
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.appeared = true
            }
        }
    }
}

#Preview {
    SidebarSpacesTabView(browserSpaces: [])
}
