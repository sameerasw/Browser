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
    
    @AppStorage("warn_before_quitting") var warnBeforeQuitting = true
    
    // Web appearance preferences
    @AppStorage("rounded_corners") var roundedCorners = true
    @AppStorage("enable_padding") var enablePadding = true
    @AppStorage("enable_shadow") var enableShadow = true
    @AppStorage("immersive_view_on_fullscreen") var immersiveViewOnFullscreen = true
    
    @AppStorage("clear_selected_tab") var clearSelectedTab = false
    
    @AppStorage("open_pip_on_tab_change") var openPipOnTabChange = true
    
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
    
    func chooseDownloadLocation() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.prompt = "Select Download Location"
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    self.downloadLocationBookmark = try url.bookmarkData(options: .withSecurityScope)
                } catch {
                    print("🔴 Error saving download location bookmark. \(error)")
                    self.downloadLocationBookmark = nil
                }
            }
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
            "open_pip_on_tab_change": true
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
