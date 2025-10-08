//
//  SidebarURL.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/20/25.
//

import SwiftUI

struct SidebarURL: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(BrowserWindowState.self) var browserWindowState
    @EnvironmentObject var userPreferences: UserPreferences
    
    @State var hover = false
    
    var body: some View {
        HStack {
            if let currentTab = browserWindowState.currentSpace?.currentTab {
                Text(currentTab.url.cleanHost)
                    .padding(.leading, 8)
                
                Spacer()
                
                if hover {
                    Button("Copy URL To Clipboard", systemImage: "link", action: browserWindowState.copyURLToClipboard)
                        .buttonStyle(.sidebarHover(hoverStyle: AnyShapeStyle(.ultraThinMaterial) ,cornerRadius: 7))
                        .padding(.trailing, .sidebarPadding)
                        .browserTransition(.opacity)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
//        .background(
//            browserWindowState.currentSpace?.textColor(in: colorScheme) == .black ?
//            AnyShapeStyle(.clear).opacity(hover ? 0.6 : 0.3) :
//                browserWindowState.currentSpace?.colors.isEmpty == true && colorScheme == .light ?
//            AnyShapeStyle(.gray).opacity(hover ? 0.3 : 0.2) :
//                AnyShapeStyle(Color.white).opacity(hover ? 0.1 : 0.05)
//        )
        .background(.clear)
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .overlay(alignment: .bottom) {
            if userPreferences.loadingIndicatorPosition == .onURL && browserWindowState.currentSpace?.currentTab?.isLoading == true {
                ProgressView(value: browserWindowState.currentSpace?.currentTab?.estimatedProgress ?? 0)
                    .progressViewStyle(.linear)
                    .frame(height: 2)
                    .tint(browserWindowState.currentSpace?.getColors.first ?? .accentColor)
            }
        }
        .clipShape(.rect(cornerRadius: 10))
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
