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
        context.coordinator.visualEffectView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        context.coordinator.update(material: material, blendingMode: blendingMode, state: state, emphasized: emphasized)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        let visualEffectView = NSVisualEffectView()
        
        init() {
            visualEffectView.blendingMode = .behindWindow
        }
        
        func update(material: NSVisualEffectView.Material,
                    blendingMode: NSVisualEffectView.BlendingMode,
                    state: NSVisualEffectView.State,
                    emphasized: Bool) {
            visualEffectView.material = material
        }
    }
}
