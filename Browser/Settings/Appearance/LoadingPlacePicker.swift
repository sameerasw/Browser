//
//  LoadingPlacePicker.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/11/25.
//

import SwiftUI

struct LoadingPlacePicker: View {
    @EnvironmentObject var userPreferences: UserPreferences
    var body: some View {
        VStack(alignment: .leading) {
            Label("Loading Indicator Position", systemImage: "progress.indicator")
            HStack {
                LoadingPickerButton(.onURL, image: .loadingPlaceURL)
                LoadingPickerButton(.onTab, image: .loadingPlaceTab)
                LoadingPickerButton(.onWebView, image: .loadingPlaceWebView)
            }
            .frame(height: 155)
        }
    }
    
    @ViewBuilder
    func LoadingPickerButton(_ value: UserPreferences.LoadingIndicatorPosition, image: ImageResource) -> some View {
        Button {
            userPreferences.loadingIndicatorPosition = value
        } label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .overlay {
                    Rectangle()
                        .strokeBorder(.blue, lineWidth: userPreferences.loadingIndicatorPosition == value ? 2 : 0)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LoadingPlacePicker()
}
