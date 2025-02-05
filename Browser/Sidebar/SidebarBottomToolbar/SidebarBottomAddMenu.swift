//
//  SidebarBottomAddMenu.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/4/25.
//

import SwiftUI
import SwiftData

/// A menu that opens from the bottom of the sidebar to create new spaces or tabs
struct SidebarBottomAddMenu: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    @EnvironmentObject var sidebarModel: SidebarModel
    @EnvironmentObject var userPreferences: UserPreferences
    
    @Query(sort: \BrowserSpace.order) var browserSpaces: [BrowserSpace]
    
    var body: some View {
        VStack(spacing: 5) {
            Button("New Space", systemImage: "plus.square.on.square") {
                sidebarModel.dismissBottomNewMenu()
                createSpace()
            }
            
            Divider()
            
            Button("New Tab", systemImage: "plus.app") {
                sidebarModel.dismissBottomNewMenu()
                browserWindowState.searchOpenLocation = .fromNewTab
            }
            .buttonStyle(.sidebarHover(font: .title3, padding: 4, fixedWidth: nil, disabled: browserSpaces.isEmpty, showLabel: true, cornerRadius: 6))
        }
        .buttonStyle(.sidebarHover(font: .title3, padding: 4, fixedWidth: nil, showLabel: true, cornerRadius: 6))
        .padding(5)
        .background()
        .macOSWindowBorderOverlay()
        .transition(.scale.animation(.bouncy(duration: 0.2)))
        .padding(.bottom, 45)
        .padding(.horizontal, .sidebarPadding)
    }
    
    func createSpace() {
        do {
            let nextIndex = browserSpaces.firstIndex(where: { $0.id == browserWindowState.currentSpace?.id }) ?? -1 + 1
            
            let newSpace = BrowserSpace(name: "", systemImage: "circle.fill", order: nextIndex, colors: [], colorScheme: "system")
            
            modelContext.insert(newSpace)
            try? modelContext.save()
            
            // Update all spaces order
            for (index, space) in browserSpaces.enumerated() {
                space.order = index
            }
            try modelContext.save()
            
            // Select the new space
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.bouncy) {
                    browserWindowState.currentSpace = newSpace
                    browserWindowState.viewScrollState = newSpace.id
                    browserWindowState.tabBarScrollState = newSpace.id
                }
            }
        } catch {
            NSAlert(error: error).runModal()
        }
    }
}
