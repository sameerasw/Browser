//
//  SplitViewState.swift
//  Browser
//
//  Created by Sameera Sandakelum on 10/8/25.
//

import SwiftUI

class SplitViewState: ObservableObject {
    @Published var columnVisibility: NavigationSplitViewVisibility = .all
}