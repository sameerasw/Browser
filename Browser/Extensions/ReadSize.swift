//
//  ReadSize.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

extension View {
    func readingWidth(width: Binding<CGFloat>) -> some View {
        self
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            width.wrappedValue = geometry.size.width
                        }
                        .onChange(of: geometry.size.width) { _, newValue in
                            width.wrappedValue = newValue
                        }
                }
            }
    }
}
