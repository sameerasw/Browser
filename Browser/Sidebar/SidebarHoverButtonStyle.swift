//
//  SidebarHoverButtonStyle.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// A ridiculously customizable button style for sidebar hover buttons
struct SidebarHoverButtonStyle: ButtonStyle {
    
    let font: Font
    let padding: CGFloat
    let colorScheme: String
    let fixedWidth: CGFloat?
    let alignment: Alignment
    let disabled: Bool
    let rotationDegrees: Double
    let showLabel: Bool
    let cornerRadius: CGFloat
    
    init(
        font: Font,
        padding: CGFloat,
        colorScheme: String,
        fixedWidth: CGFloat?,
        alignment: Alignment,
        disabled: Bool,
        rotationDegrees: Double,
        showLabel: Bool,
        cornerRadius: CGFloat
    ) {
        self.font = font
        self.padding = padding
        self.colorScheme = colorScheme
        self.fixedWidth = fixedWidth
        self.alignment = alignment
        self.disabled = disabled
        self.rotationDegrees = rotationDegrees
        self.showLabel = showLabel
        self.cornerRadius = cornerRadius
    }
    
    @State private var hover = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .dynamicLabelStyle(showLabel: showLabel)
            .rotationEffect(.degrees(rotationDegrees))
            .foregroundStyle(disabled ? .secondary : .primary)
            .font(font)
            .fixedFrame(width: fixedWidth, alignment: alignment)
            .padding(padding)
            .background(hover ? AnyShapeStyle(.white.opacity(0.4)) : AnyShapeStyle(.clear))
            .clipShape(.rect(cornerRadius: cornerRadius))
            .onHover { hover in
                self.hover = hover
            }
            .disabled(disabled)
    }
}

fileprivate extension View {
    @ViewBuilder
    func dynamicLabelStyle(showLabel: Bool) -> some View {
        if showLabel {
            self.labelStyle(.titleAndIcon)
        } else {
            self.labelStyle(.iconOnly)
        }
    }
    
    @ViewBuilder
    func fixedFrame(width: CGFloat?, alignment: Alignment) -> some View {
        if let width {
            self.frame(width: width, height: width, alignment: .center)
        } else {
            self.frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}

extension ButtonStyle where Self == SidebarHoverButtonStyle {
    static func sidebarHover(
        font: Font = .system(size: 17),
        padding: CGFloat = .zero,
        colorScheme: String = "Light",
        fixedWidth: CGFloat? = 25,
        alignment: Alignment = .leading,
        disabled: Bool = false,
        rotationDegrees: Double = 0,
        showLabel: Bool = false,
        cornerRadius: CGFloat = 4
    ) -> SidebarHoverButtonStyle {
        SidebarHoverButtonStyle(
            font: font,
            padding: padding,
            colorScheme: colorScheme,
            fixedWidth: fixedWidth,
            alignment: alignment,
            disabled: disabled,
            rotationDegrees: rotationDegrees,
            showLabel: showLabel,
            cornerRadius: cornerRadius
        )
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(.sidebarHover())
}
