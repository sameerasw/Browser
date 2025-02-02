//
//  SidebarSpaceClearDivider.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/1/25.
//

import SwiftUI

struct SidebarSpaceClearDivider: View {
    
    @Environment(\.modelContext) var modelContext
    
    let browserSpace: BrowserSpace
    let isHovering: Bool
    
    @State var isHoveringClearButton = false
    
    var body: some View {
        HStack {
            VStack {
                Divider()
            }
            
            if !browserSpace.tabs.isEmpty && isHovering {
                Button {
                    withAnimation(.bouncy) {
                        for tab in browserSpace.tabs {
                            modelContext.delete(tab)
                        }
                        try? modelContext.save()
                    }
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "xmark.circle")
                        Text("Clear")
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(isHoveringClearButton ? .primary : .secondary)
                .onHover {
                    isHoveringClearButton = $0
                }
            }
        }
        .padding(.leading, .sidebarPadding * 2)
        .padding(.trailing, .sidebarPadding)
        .padding(.top)
        .frame(height: 30)
    }
}
