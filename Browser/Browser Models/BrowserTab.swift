//
//  BrowserTab.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftData
import WebKit
import Combine
import FaviconFinder

/// A model that represents a tab in the browser
@Model
final class BrowserTab: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var title: String
    var favicon: Data?
    var url: URL
    var order: Int
    
    @Relationship var browserSpace: BrowserSpace?
    
    init(title: String, favicon: Data? = nil, url: URL, order: Int, browserSpace: BrowserSpace?) {
        self.id = UUID()
        self.title = title
        self.favicon = favicon
        self.url = url
        self.browserSpace = browserSpace
        self.order = order
    }
    
    @Transient var webview: MyWKWebView? = nil {
        didSet {
            observeWebView()
        }
    }
    
    @Attribute(.ephemeral) private(set) var canGoBack: Bool = false
    @Attribute(.ephemeral) private(set) var canGoForward: Bool = false
    @Transient private var cancellables = Set<AnyCancellable>()

    /// Observes the webview to update the tab's properties, such as the title, favicon, url, and navigation buttons...
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
        
        webview.publisher(for: \.url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                guard let url else { return }
                self?.url = url
            }
            .store(in: &cancellables)
        
        webview.publisher(for: \.title)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                if let title, !title.isEmpty {
                    self?.title = title
                } else {
                    self?.title = self?.url.cleanHost ?? ""
                }
            }
            .store(in: &cancellables)
    }
    
    /// Updates the tab's favicon with the largest image found in the website
    /// - Parameter url: The URL of the website to find the favicon
    func updateFavicon(with url: URL) {
        Task {
            do {
                let favicon = try await FaviconFinder(url: url)
                    .fetchFaviconURLs()
                    .download()
                    .largest()
                    .image?.data
                    
                if let favicon = favicon {
                    self.favicon = favicon
                } else {
                    print("Failed to find favicon for: \(url.cleanHost)")
                }
            } catch {
                print("Error finding favicon: \(error.localizedDescription)")
            }
        }
    }
    
    /// Stops observing the webview
    func stopObserving() {
        cancellables.removeAll()
    }
}
