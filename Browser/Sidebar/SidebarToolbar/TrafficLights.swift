//
//  TrafficLights.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

/// Three circles that mimic the native macOS window traffic lights
struct TrafficLights: View {
    
    @EnvironmentObject var preferences: UserPreferences
    
    let colors: [Color] = [.red, .yellow, .green]
    let size: CGFloat = 12
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
            }
        }
        .padding(.leading, .approximateTrafficLightsLeadingPadding)
    }
}

#Preview {
    TrafficLights()
}
