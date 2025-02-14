//
//  SharedWebViewConfiguration.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import WebKit

/// Shared configuration for WKWebView instances
class SharedWebViewConfiguration {
    // Singleton to ensure a single shared configuration across tabs
    static let shared = SharedWebViewConfiguration()
    
    // Shared configuration with cache, cookies, and other settings
    let configuration: WKWebViewConfiguration
    
    private init() {
        configuration = WKWebViewConfiguration()
        
        configuration.allowsInlinePredictions = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.websiteDataStore = .default()
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Configure shared preferences
        let preferences = WKPreferences()
        preferences.isElementFullscreenEnabled = true
        preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        ExperimentalFeatures.toggleExperimentalFeature("PreferPageRenderingUpdatesNear60FPSEnabled", enabled: false, preferences: preferences)
        ExperimentalFeatures.toggleExperimentalFeature("ApplePayEnabled", enabled: true, preferences: preferences)
        
        configuration.preferences = preferences
        
        let webPagePreferences = WKWebpagePreferences()
        webPagePreferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = webPagePreferences
    }
}
