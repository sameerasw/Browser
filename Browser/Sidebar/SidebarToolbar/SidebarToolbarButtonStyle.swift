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
            .font(.title2)
            .frame(width: 30, height: 30, alignment: .center)
            .background(hover ? AnyShapeStyle(.thickMaterial) : AnyShapeStyle(.clear))
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
