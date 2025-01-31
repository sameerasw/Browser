//
//  WKCoordinator.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import Foundation

/// `WKCoordinator` is the coordinator for the `WKWebViewRepresentable` view.
class WKCoordinator {
    let navigationDelegateCoordinator: WKNavigationDelegateCoordinator
    let uiDelegateCoordinator: WKUIDelegateCoordinator
    
    init(_ parent: WKWebViewRepresentable) {
        self.navigationDelegateCoordinator = WKNavigationDelegateCoordinator(parent)
        self.uiDelegateCoordinator = WKUIDelegateCoordinator(parent)
    }
}
