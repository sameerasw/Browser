//
//  SidebarTab.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import SwiftUI

struct SidebarTab: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var browserWindowState: BrowserWindowState
    
    @Bindable var browserTab: BrowserTab
    
    @State var backgroundColor: Color = .clear
    @State var isHoveringTab: Bool = false
    @State var isHoveringCloseButton: Bool = false
    
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 30)
        .padding(3)
        .background(
            ZStack {
                if let currentTab = browserWindowState.currentSpace?.currentTab {
                    if currentTab as AnyHashable == browserTab as AnyHashable {
                        Color.white.opacity(0.6)
                    } else if isHoveringTab {
                        Color.white.opacity(0.3)
                    } else {
                        Color.clear
                    }
                }
            }
        )
        .clipShape(.rect(cornerRadius: 10))
        .onHover { hover in
            self.isHoveringTab = hover
        }
    }
    
    var faviconImage: some View {
        Group {
            if let favicon = browserTab.favicon, let nsImage = NSImage(data: favicon) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .clipShape(.rect(cornerRadius: 4))
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray))
                    .frame(width: 16, height: 16)
            }
        }
        .padding(.leading, 5)
    }
    
    var closeTabButton: some View {
        Button("Close Tab", systemImage: "xmark", action: closeTab)
        .font(.title3)
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(4)
        .background(isHoveringCloseButton ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.clear))
        .clipShape(.rect(cornerRadius: 6))
        .onHover { hover in
            self.isHoveringCloseButton = hover
        }
        .padding(.trailing, 5)
    }
    
    func closeTab() {
        withAnimation(.bouncy(duration: 0.01, extraBounce: 0.9)) {
            modelContext.delete(browserTab)
            try? modelContext.save()
        }
    }
}
