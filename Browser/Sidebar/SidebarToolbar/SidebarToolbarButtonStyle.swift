//
//  SidebarToolbarButtonStyle.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct SidebarToolbarButtonStyle: ButtonStyle {
    @State private var hover = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17))
            .frame(width: 25, height: 25, alignment: .center)
            .background(hover ? AnyShapeStyle(.background.opacity(0.4)) : AnyShapeStyle(.clear))
            .clipShape(.rect(cornerRadius: 4))
            .onHover { hover in
                self.hover = hover
            }
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(SidebarToolbarButtonStyle())
}
