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
    
    @State var viewScrollState: BrowserSpace?

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
                    withAnimation(.bouncy) {
                        browserWindowState.tabBarScrollState = newValue
                        browserWindowState.currentSpace = browserSpaces.first { $0.id == newValue }
                    }
                }
            }
        }
        .task {
            browserWindowState.loadCurrentSpace(browserSpaces: browserSpaces)
        }
    }
}

#Preview {
    SidebarSpacesTabView(browserSpaces: [])
}
