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
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    let browserSpaces: [BrowserSpace]
    
    @State var appeared = false
    @State var lastWidth = CGFloat.zero
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(browserSpaces) { browserSpace in
                    if browserSpace.name.isEmpty {
                        SidebarSpaceCreateView(browserSpaces: browserSpaces, browserSpace: browserSpace)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    } else {
                        SidebarSpaceView(browserSpaces: browserSpaces, browserSpace: browserSpace)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
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
                withAnimation(appeared ? .browserDefault : nil) {
                    browserWindowState.tabBarScrollState = newValue
                    browserWindowState.currentSpace = browserSpaces.first { $0.id == newValue }
                }
            }
            
            // Delete browserSpaces with empty names if they are not the one selected
            if let currentSpace = browserWindowState.currentSpace, !currentSpace.name.isEmpty {
                for space in browserSpaces where space.name.isEmpty {
                    modelContext.delete(space)
                }
                
                // Update order of spaces
                for (index, space) in browserSpaces.enumerated() {
                    space.order = index
                }
                try? modelContext.save()
            }
        }
        // This is a workaround to prevent the animation when the view first appears
        .transaction { $0.disablesAnimations = !appeared }
        .onAppear {
            if browserWindowState.currentSpace == nil {
                browserWindowState.loadCurrentSpace(browserSpaces: browserSpaces)
            }
                        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.appeared = true
            }
        }
    }
}

#Preview {
    SidebarSpacesTabView(browserSpaces: [])
}
