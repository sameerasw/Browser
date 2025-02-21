//
//  SidebarURL.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/20/25.
//

import SwiftUI

struct SidebarURL: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    @State var hover = false
        
    var body: some View {
        HStack {
            if let currentTab = browserWindowState.currentSpace?.currentTab {
                Text(currentTab.url.cleanHost)
                    .padding(.leading, .sidebarPadding)
                
                Spacer()
                
                if hover {
                    Button("Copy URL To Clipboard", systemImage: "link", action: browserWindowState.copyURLToClipboard)
                        .buttonStyle(.sidebarHover(hoverStyle: AnyShapeStyle(.ultraThinMaterial) ,cornerRadius: 7))
                        .padding(.trailing, .sidebarPadding)
                        .transition(.opacity)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 30)
        .padding(3)
        .background(browserWindowState.currentSpace?.textColor(in: colorScheme) == .black ? AnyShapeStyle(.ultraThinMaterial).opacity(hover ? 0.6 : 0.3) : AnyShapeStyle(Color.white).opacity(hover ? 0.1 : 0.05))
        .clipShape(.rect(cornerRadius: 10))
        .padding(.leading, .sidebarPadding)
        .onTapGesture {
            browserWindowState.searchOpenLocation = .fromURLBar
        }
        .onHover { hover in
            withAnimation(.browserDefault?.speed(2)) {
                self.hover = hover
            }
        }
        .zIndex(-1)
    }
}

#Preview {
    SidebarURL()
}
