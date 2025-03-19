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
    let hoverStyle: AnyShapeStyle
    let colorScheme: String
    let fixedWidth: CGFloat?
    let alignment: Alignment
    let enabledColor: Color
    let hoverColor: Color
    let disabled: Bool
    let disabledColor: Color
    let rotationDegrees: Double
    let showLabel: Bool
    let cornerRadius: CGFloat
    
    @State private var hover = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .dynamicLabelStyle(showLabel: showLabel)
            .rotationEffect(.degrees(rotationDegrees))
            .foregroundStyle(disabled ? disabledColor : hover ? hoverColor : enabledColor)
            .font(font)
            .fixedFrame(width: fixedWidth, alignment: alignment)
            .padding(padding)
            .background(hover ? hoverStyle : AnyShapeStyle(.clear))
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
    /// A ridiculously customizable button style for sidebar hover buttons
    static func sidebarHover(
        font: Font = .system(size: 17),
        padding: CGFloat = .zero,
        hoverStyle: AnyShapeStyle = AnyShapeStyle(.white.opacity(0.4)),
        colorScheme: String = "Light",
        fixedWidth: CGFloat? = 25,
        alignment: Alignment = .leading,
        enabledColor: Color = .primary,
        hoverColor: Color = .primary,
        disabled: Bool = false,
        disabledColor: Color = .secondary,
        rotationDegrees: Double = 0,
        showLabel: Bool = false,
        cornerRadius: CGFloat = 4
    ) -> SidebarHoverButtonStyle {
        SidebarHoverButtonStyle(
            font: font,
            padding: padding,
            hoverStyle: hoverStyle,
            colorScheme: colorScheme,
            fixedWidth: fixedWidth,
            alignment: alignment,
            enabledColor: enabledColor,
            hoverColor: hoverColor,
            disabled: disabled,
            disabledColor: disabledColor,
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
