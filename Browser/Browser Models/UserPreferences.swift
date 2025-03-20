//
//  UserPreferences.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

/// User preferences that are stored in AppStorage
class UserPreferences: ObservableObject {
    
    enum SidebarPosition: String {
        case leading
        case trailing
    }
    
    // App appearance preferences
    @AppStorage("disable_animations") var disableAnimations = false
    @AppStorage("sidebar_position") var sidebarPosition = SidebarPosition.leading {
        didSet {
            changeTrafficLightsTrailingAppearance()
        }
    }
    @AppStorage("show_window_controls_trailing_sidebar") var showWindowControlsOnTrailingSidebar = true {
        didSet {
            changeTrafficLightsTrailingAppearance()
        }
    }
    @AppStorage("reverse_colors_on_trailing_sidebar") var reverseColorsOnTrailingSidebar = true
    
    enum LoadingIndicatorPosition: Int {
        case onURL
        case onTab
        case onWebView
    }
    @AppStorage("loading_indicator_position") var loadingIndicatorPosition = LoadingIndicatorPosition.onURL
    
    // Web appearance preferences
    @AppStorage("rounded_corners") var roundedCorners = true
    @AppStorage("enable_padding") var enablePadding = true
    @AppStorage("enable_shadow") var enableShadow = true
    @AppStorage("immersive_view_on_fullscreen") var immersiveViewOnFullscreen = true
    
    // General preferences
    @AppStorage("clear_selected_tab") var clearSelectedTab = false
    @AppStorage("open_pip_on_tab_change") var openPipOnTabChange = true
    @AppStorage("warn_before_quitting") var warnBeforeQuitting = true
    
    @AppStorage("automatic_page_suspension") var automaticPageSuspension = true
    
    @AppStorage("custom_website_searchers") var customWebsiteSearchers = [BrowserCustomSearcher]()
    
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
    
    func changeTrafficLightsTrailingAppearance() {
        if sidebarPosition == .trailing {
            NSApp.setBrowserWindowControls(hidden: !showWindowControlsOnTrailingSidebar)
        }
    }
    
    init() {
        registerAllDefaults()
        getDownloadsFolder()
    }
    
    func registerAllDefaults() {
        UserDefaults.standard.register(defaults: [
            "disable_animations": false,
            "sidebar_position": SidebarPosition.leading.rawValue,
            "show_window_controls_trailing_sidebar": true,
            "reverse_colors_on_trailing_sidebar": true,
            "warn_before_quitting": true,
            "rounded_corners": true,
            "enable_padding": true,
            "enable_shadow": true,
            "immersive_view_on_fullscreen": true,
            "clear_selected_tab": false,
            "open_pip_on_tab_change": true,
            "loading_indicator_position": LoadingIndicatorPosition.onURL.rawValue,
            "automatic_page_suspension": true
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
