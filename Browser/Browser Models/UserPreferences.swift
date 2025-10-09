//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

/// User preferences that are stored in AppStorage
class UserPreferences: ObservableObject {
    
    enum WindowBackgroundStyle: String {
        case thinMaterial
        case liquidGlass
    }
    
    // App appearance preferences
    @AppStorage("disable_animations") var disableAnimations = false
    
    @AppStorage("window_background_style") var windowBackgroundStyle = WindowBackgroundStyle.thinMaterial
    
    enum LoadingIndicatorPosition: Int {
        case onURL
        case onTab
        case onWebView
    }
    @AppStorage("loading_indicator_position") var loadingIndicatorPosition = LoadingIndicatorPosition.onURL
    
    // Web appearance preferences
    @AppStorage("rounded_corners") var roundedCorners = true
    @AppStorage("web_content_transparency") var webContentTransparency = false
    
    // General preferences
    @AppStorage("clear_selected_tab") var clearSelectedTab = false
    @AppStorage("open_pip_on_tab_change") var openPipOnTabChange = true
    @AppStorage("warn_before_quitting") var warnBeforeQuitting = true
    
    @AppStorage("automatic_page_suspension") var automaticPageSuspension = true
    
    @AppStorage("custom_website_searchers") var customWebsiteSearchers = [BrowserCustomSearcher]()
    
    @AppStorage("show_hover_url") var showHoverURL = true
    
    @AppStorage("extended_sidebar_style") var extendedSidebarStyle = false
    
    // Download preferences
    @Published var downloadLocationBookmark: Data? = nil {
        didSet {
            UserDefaults.standard.set(downloadLocationBookmark, forKey: "download_location_bookmark")
        }
    }
    var downloadURL: URL? {
        guard let downloadLocationBookmark = downloadLocationBookmark else { return nil }
        
        var isStale = false
        do {
            let url = try URL(resolvingBookmarkData: downloadLocationBookmark, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
            if isStale {
                UserDefaults.standard.removeObject(forKey: "download_location_bookmark")
                return nil
            }
            return url
        } catch {
            return nil
        }
    }
    
    init() {
        registerAllDefaults()
        getDownloadsFolder()
    }
    
    func registerAllDefaults() {
        UserDefaults.standard.register(defaults: [
            "disable_animations": false,
            "window_background_style": WindowBackgroundStyle.thinMaterial.rawValue,
            "warn_before_quitting": true,
            "rounded_corners": true,
            "clear_selected_tab": false,
            "open_pip_on_tab_change": true,
            "loading_indicator_position": LoadingIndicatorPosition.onURL.rawValue,
            "automatic_page_suspension": true,
            "show_hover_url": true,
            "web_content_transparency": false,
            "extended_sidebar_style": false
        ])
    }
    
    func getDownloadsFolder() {
        if let downloadLocationBookmark = UserDefaults.standard.data(forKey: "download_location_bookmark") {
            var isStale = false
            if (try? URL(resolvingBookmarkData: downloadLocationBookmark, options: .withSecurityScope, bookmarkDataIsStale: &isStale)) != nil {
                if isStale {
                    print("⚠️ Download bookmark is stale.")
                    UserDefaults.standard.removeObject(forKey: "download_location_bookmark")
                } else {
                    self.downloadLocationBookmark = downloadLocationBookmark
                }
            }
        }
    }
}
