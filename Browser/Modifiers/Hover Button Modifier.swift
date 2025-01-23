//
//  Hover Button Modifier.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct HoverButtonStyle: ButtonStyle {
    @State private var isHovering = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .buttonStyle(.plain)
            .frame(width: 20, height: 20)
            .padding(6)
            .background(isHovering ? .white.opacity(0.1) : .clear)
            .clipShape(.rect(cornerRadius: 4))
            .onHover { isHovering in
                withAnimation(.spring(duration: 0.1)) {
                    self.isHovering = isHovering
                }
            }
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(HoverButtonStyle())
}

struct HoverButtonModifier: ViewModifier {
    @State private var isHovering = false
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .buttonStyle(.plain)
            .frame(width: 20, height: 20)
            .padding(6)
            .background(isHovering ? .white.opacity(0.1) : .clear)
            .clipShape(.rect(cornerRadius: 4))
            .onHover { isHovering in
                withAnimation(.spring(duration: 0.1)) {
                    self.isHovering = isHovering
                }
            }
    }
}

extension View {
    func hoverButtonStyle() -> some View {
        modifier(HoverButtonModifier())
    }
}

#Preview {
    Button("", systemImage: "sidebar.left") {
    }
    .modifier(HoverButtonModifier())
}
