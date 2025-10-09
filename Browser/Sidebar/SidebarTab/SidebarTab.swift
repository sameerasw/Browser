//
//  SidebarTab.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import SwiftUI

/// Tab in the sidebar
struct SidebarTab: View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext

    @EnvironmentObject var userPreferences: UserPreferences

    @Bindable var browserSpace: BrowserSpace
    @Bindable var browserTab: BrowserTab

    let dragging: Bool

    @State var backgroundColor: Color = .clear
    @State var isHoveringTab: Bool = false
    @State var isHoveringCloseButton: Bool = false
    @State var isPressed: Bool = false

    var body: some View {
        HStack {
            faviconImage

            Text(browserTab.title)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            if isHoveringTab {
                closeTabButton
            }
        }
                .opacity(getTabOpacity())
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 30)
        .padding(3)
        .background(dragging ? .white.opacity(0.1) : browserSpace.currentTab == browserTab ? browserSpace.textColor(in: colorScheme) == .black ? .white : .white.opacity(0.2) : isHoveringTab ? .white.opacity(0.1) : .clear)
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture(perform: selectTab)
        .onMiddleClick {
            closeTab()
        }
        .onHover { hover in
            self.isHoveringTab = hover
        }
        .contextMenu {
            SidebarTabContextMenu(browserTab: browserTab)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
    }

    var faviconImage: some View {
        Group {
            if userPreferences.loadingIndicatorPosition == .onTab && browserTab.isLoading {
                ProgressView()
                    .controlSize(.small)
            } else if let favicon = browserTab.favicon, let nsImage = NSImage(data: favicon) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 4))
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray))
            }
        }
        .frame(width: 16, height: 16)
        .padding(.leading, 5)
    }

    var closeTabButton: some View {
        let isPinned = browserSpace.pinnedTabs.contains(browserTab)
        let buttonText = isPinned ? (browserTab.isSuspended ? "Close Tab" : "Suspend Tab") : "Close Tab"
        
        return Button(buttonText, systemImage: "xmark", action: closeTab)
            .font(.title3)
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .padding(4)
            .background(isHoveringCloseButton ? AnyShapeStyle(.ultraThinMaterial.opacity(0.4)) : AnyShapeStyle(.clear))
            .clipShape(.rect(cornerRadius: 6))
            .onHover { hover in
                self.isHoveringCloseButton = hover
            }
            .padding(.trailing, 5)
    }
    
    func getTabOpacity() -> Double {
        if browserTab.isSuspended {
            return 0.5
        }
        if !browserSpace.loadedTabs.contains(browserTab) {
            return 0.7
        }
        return 1.0
    }

    func selectTab() {
        browserSpace.currentTab = browserTab
        
        // Load tab if not loaded
        if !browserSpace.loadedTabs.contains(browserTab) {
            browserSpace.loadedTabs.append(browserTab)
        }
        
        // Reload suspended tab
        if browserTab.isSuspended {
            browserTab.isSuspended = false
            browserTab.reload()
        }
        
        // Reset suspend timer for unpinned tabs
        if !browserSpace.pinnedTabs.contains(browserTab) {
            browserTab.viewController?.resetSuspendTimer()
        }

        if !userPreferences.disableAnimations {
            // Scale bounce effect
            withAnimation(.bouncy(duration: 0.15, extraBounce: 0.0)) {
                isPressed = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }

    /// Close (delete) the tab
    func closeTab() {
        browserSpace.closeTab(browserTab, using: modelContext)
    }
}
