//
//  SidebarSpaceBackground.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/11/25.
//

import SwiftUI

struct SidebarSpaceBackground: View {
    
    let browserSpace: BrowserSpace
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1/30)) { _ in
            if !browserSpace.colors.isEmpty && browserSpace.colorOpacity > 0 && browserSpace.grainOpacity > 0 {
                let grainOpacity = browserSpace.grainOpacity
                gradient
                    .visualEffect { content, proxy in
                        content
                            .colorEffect(
                                ShaderLibrary.noiseShader(
                                    .float2(proxy.size),
                                    .float(0)
                                )
                            )
                            .opacity(grainOpacity)
                    }
                    .drawingGroup(opaque: true)
                    .background {
                        gradient
                            .opacity(browserSpace.colorOpacity)
                    }
            }
        }
    }
    
    var gradient: some View {
        LinearGradient(colors: browserSpace.getColors, startPoint: .leading, endPoint: .trailing)
    }
}
