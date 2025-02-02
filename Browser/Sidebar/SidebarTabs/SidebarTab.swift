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
    
    @Bindable var browserSpace: BrowserSpace
    @Bindable var browserTab: BrowserTab
    
    @State var backgroundColor: Color = .clear
    @State var isHoveringTab: Bool = false
    @State var isHoveringCloseButton: Bool = false
    @State var isPressed: Bool = false
    
    var body: some View {
        Button {
            browserSpace.currentTab = browserTab
            withAnimation(.bouncy(duration: 0.15, extraBounce: 0.0)) {
                isPressed = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        } label: {
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
            .background(browserSpace.currentTab == browserTab ? .white.opacity(0.2) : isHoveringTab ? .white.opacity(0.1) : .clear)
            .clipShape(.rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .onHover { hover in
            self.isHoveringTab = hover
        }
        .contextMenu {
            Button("Print Tab") {
                print(browserTab)
            }
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
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
