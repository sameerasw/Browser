//
//  SidebarBottomToolbar.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

/// Bottom toolbar for the sidebar
struct SidebarBottomToolbar: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    @EnvironmentObject var userPreferences: UserPreferences
    
    let browserSpaces: [BrowserSpace]
    let createSpace: () -> Void
    
    @State var isAnimating = false
    
    var body: some View {
        HStack {
            Button("Downloads", systemImage: "circle") {
                withAnimation(.browserDefault) {
                    sidebarModel.showDownloads.toggle()
                    if !sidebarModel.showDownloads {
                        sidebarModel.allowDownloadHover = false
                    }
                } completion: {
                    if sidebarModel.showDownloads {
                        sidebarModel.allowDownloadHover = true
                    }
                }
            }
            .buttonStyle(.sidebarHover(padding: 2))
            .contextMenu {
                Button("Open Downloads Folder") {
                    if let downloadURL = userPreferences.downloadURL {
                        guard downloadURL.startAccessingSecurityScopedResource() else { return }
                        NSWorkspace.shared.open(downloadURL)
                        downloadURL.stopAccessingSecurityScopedResource()
                    }
                }
            }
            .overlay {
                Image(systemName: "arrow.down")
                    .resizable()
                    .fontWeight(.bold)
                    .scaledToFit()
                    .frame(width: isAnimating ? 125 : 7)
                    .offset(y: isAnimating ? -125 : 0)
                    .rotationEffect(.degrees(isAnimating ? 20 : 0))
                    .animation(.interpolatingSpring(stiffness: 200, damping: 6), value: isAnimating)
                    .onChange(of: isAnimating) { _, _ in
                        // Reverse animation
                        if isAnimating {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                isAnimating.toggle()
                            }
                        }
                    }
                    .allowsHitTesting(false)
            }
            
            Spacer()
            
            Button("Toggle animation") {
                withAnimation(.interpolatingSpring(stiffness: 200, damping: 6)) {
                    isAnimating.toggle()
                }
            }
            
            if browserWindowState.isMainBrowserWindow {
                SidebarSpaceList(browserSpaces: browserSpaces)
                
                Button("New Space", systemImage: "plus.circle.dashed", action: createSpace)
                    .buttonStyle(.sidebarHover(padding: 2))
            }
        }
        .padding(.leading, .sidebarPadding)
    }
}

#Preview {
    SidebarBottomToolbar(browserSpaces: [], createSpace: {})
}
