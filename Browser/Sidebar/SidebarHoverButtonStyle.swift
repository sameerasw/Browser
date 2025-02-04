//
//  SidebarHoverButtonStyle.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// Button style for sidebar hover buttons
struct SidebarHoverButtonStyle: ButtonStyle {
    
    let padding: CGFloat
    let colorScheme: String
    let disabled: Bool
    
    init(padding: CGFloat = .zero, colorScheme: String, disabled: Bool) {
        self.padding = padding
        self.colorScheme = colorScheme
        self.disabled = disabled
    }
    
    @State private var hover = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(disabled ? .secondary : .primary)
            .labelStyle(.iconOnly)
            .font(.system(size: 17))
            .frame(width: 25, height: 25, alignment: .center)
            .padding(padding)
            .background(hover ? AnyShapeStyle(.white.opacity(0.4)) : AnyShapeStyle(.clear))
            .clipShape(.rect(cornerRadius: 4))
            .onHover { hover in
                self.hover = hover
            }
            .disabled(disabled)
    }
}

extension ButtonStyle where Self == SidebarHoverButtonStyle {
    static func sidebarHover(padding: CGFloat = .zero, colorScheme: String = "Light", disabled: Bool = false) -> SidebarHoverButtonStyle {
        SidebarHoverButtonStyle(padding: padding, colorScheme: colorScheme, disabled: disabled)
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(.sidebarHover())
}
