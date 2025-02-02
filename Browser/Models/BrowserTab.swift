//
//  BrowserTab.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftData
import WebKit
import Combine

@Model
final class BrowserTab: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var title: String
    var favicon: Data?
    var url: URL
    
    @Relationship var browserSpace: BrowserSpace?
    
    init(title: String, favicon: Data? = nil, url: URL, browserSpace: BrowserSpace) {
        self.id = UUID()
        self.title = title
        self.favicon = favicon
        self.url = url
        self.browserSpace = browserSpace
    }
    
    @Transient var webview: WKWebView? = nil {
        didSet {
            observeWebView()
        }
    }
    
    @Attribute(.ephemeral) private(set) var canGoBack: Bool = false
    @Attribute(.ephemeral) private(set) var canGoForward: Bool = false
    @Transient private var cancellables = Set<AnyCancellable>()

    private func observeWebView() {
        guard let webview else { return }
        
        webview.publisher(for: \.canGoBack)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canGoBack in
                self?.canGoBack = canGoBack
            }
            .store(in: &cancellables)
        
        webview.publisher(for: \.canGoForward)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canGoForward in
                self?.canGoForward = canGoForward
            }
            .store(in: &cancellables)
    }
}
