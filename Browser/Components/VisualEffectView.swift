//
//  VisualEffect.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/25/25.
//  https://cindori.com/developer/floating-panel
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State = .followsWindowActiveState
    var emphasized: Bool = true
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        NSVisualEffectView()
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
        nsView.isEmphasized = emphasized
    }
}
