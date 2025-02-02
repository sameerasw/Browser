//
//  SidebarSpacesTabView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI
import SwiftData

struct SidebarSpacesTabView: View {
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    let browserSpaces: [BrowserSpace]
    
    @State var appeared = false
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: .zero) {
                    ForEach(browserSpaces) { browserSpace in
                        SidebarSpaceView(browserSpaces: browserSpaces, browserSpace: browserSpace)
                            .frame(width: size.width, height: size.height)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $browserWindowState.viewScrollState)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .onChange(of: browserWindowState.viewScrollState) { oldValue, newValue in
                if let newValue {
                    withAnimation(appeared ? .bouncy : nil) {
                        browserWindowState.tabBarScrollState = newValue
                        browserWindowState.currentSpace = browserSpaces.first { $0.id == newValue }
                    }
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
