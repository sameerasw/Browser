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
        print("Observing")
        
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
    
    func updateFavicon(with url: URL) {
        Task {
            do {
                let favicon = try await FaviconFinder(url: url)
                    .fetchFaviconURLs()
                    .download()
                    .smallest()
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
    
    func stopObserving() {
        cancellables.removeAll()
    }
}
