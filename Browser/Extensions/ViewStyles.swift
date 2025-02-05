//
//  ViewStyles.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/4/25.
//

import SwiftUI

/// View modifier to mimic macOS window border
struct WindowBorderOverlay: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = 10) {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(colorScheme == .light ? AnyShapeStyle(.ultraThickMaterial) : AnyShapeStyle(.white.opacity(0.1)), lineWidth: 1)
            )
    }
}

extension View {
    func macOSWindowBorderOverlay(cornerRadius: CGFloat = 10) -> some View {
        modifier(WindowBorderOverlay(cornerRadius: cornerRadius))
    }
}
