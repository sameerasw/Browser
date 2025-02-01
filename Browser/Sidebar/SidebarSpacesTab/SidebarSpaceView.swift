//
//  SidebarSpaceView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI

struct SidebarSpaceView: View {
    @Bindable var browserSpace: BrowserSpace
    var body: some View {
        LazyVStack {
            Label(browserSpace.name, systemImage: browserSpace.systemImage)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, .sidebarPadding)
    }
}
