//
//  MyWKWebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import WebKit

/// Custom WKWebView subclass to handle context menus
class MyWKWebView: WKWebView {
    
    private let zoomFactors: [CGFloat] = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 4, 5, 6]
    var scaledZoomFactor: CGFloat? = nil
    
    override var isEditable: Bool {
        get {
            return _isEditable
        }
        set {
            _isEditable = newValue
        }
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func zoomActualSize() {
        setZoomFactor(1.0)
        scaledZoomFactor = 1.0
        saveZoomFactor()
    }
    
    /// Handle Zoom In
    func zoomIn() {
        guard let scaledZoomFactor else { return }
        let currentIndex = zoomFactors.firstIndex(of: scaledZoomFactor) ?? 3
        let nextIndex = currentIndex + 1
        if nextIndex < zoomFactors.count {
            let nextZoomFactor = zoomFactors[nextIndex]
            setZoomFactor(nextZoomFactor)
            self.scaledZoomFactor = nextZoomFactor
            saveZoomFactor()
        }
    }
    
    /// Handle Zoom Out
    func zoomOut() {
        guard let scaledZoomFactor else { return }
        let currentIndex = zoomFactors.firstIndex(of: scaledZoomFactor) ?? 3
        let nextIndex = currentIndex - 1
        if nextIndex >= 0 {
            let nextZoomFactor = zoomFactors[nextIndex]
            setZoomFactor(nextZoomFactor)
            self.scaledZoomFactor = nextZoomFactor
            saveZoomFactor()
        }
    }
    
    /// Sets the zoom factor
    /// - Parameter zoomFactor: The zoom factor to set
    /// - Returns: A boolean indicating if the zoom factor was set
    func setZoomFactor(_ zoomFactor: CGFloat) {
        let zoomScript = "document.body.style.zoom = '\(zoomFactor)';"
        evaluateJavaScript(zoomScript)
    }
    
    /// Get saved zoom factor
    /// - Returns: The saved zoom factor
    func savedZoomFactor() -> CGFloat {
        let savedZoomFactors = UserDefaults.standard.dictionary(forKey: "zoom_factors")
        return savedZoomFactors?[url?.cleanHost ?? ""] as? CGFloat ?? 1.0
    }
    
    /// Save zoom factor
    func saveZoomFactor() {
        guard let host = url?.cleanHost else { return }
        var savedZoomFactors = UserDefaults.standard.dictionary(forKey: "zoom_factors") ?? [:]
        savedZoomFactors[host] = scaledZoomFactor
        UserDefaults.standard.set(savedZoomFactors, forKey: "zoom_factors")
    }
    
    /// Toggles the page editable
    func toggleEditable() {
        isEditable.toggle()
        print(isEditable)
    }
    
    /// Clears the cookies of the specific host and reloads
    func clearCookiesAndReload() {
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        cookieStore.getAllCookies { cookies in
            for cookie in cookies where self.url?.host()?.contains(cookie.domain) == true {
                cookieStore.delete(cookie)
            }
        }
        reload()
    }
    
    /// Clears the cache of the specific host and reloads
    func clearCacheAndReload() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            for record in records where self.url?.host()?.contains(record.displayName) == true {
                let types = record.dataTypes.filter { $0.contains("Cache") }
                WKWebsiteDataStore.default().removeData(ofTypes: types, for: [record], completionHandler: {})
            }
        }
        reload()
    }
    
    /// Toggles the developer tools
    func toggleDeveloperTools() {
        DeveloperFeatures.toggleWebInspector(for: self)
    }
    
    /// Gets the current page's muted state
    var mediaMutedState: WKMediaMutedState {
        MediaControls.getPageMutedState(for: self)
    }
    
    /// Sets the page muted state
    func setPageMuted(_ mutedState: WKMediaMutedState) {
        MediaControls.setPageMuted(mutedState, for: self)
    }
    
    /// Toggles the page muted state
    func toggleMute() {
        setPageMuted(mediaMutedState == .audioMuted ? [] : .audioMuted)
    }
    
    /// Gets if the page has an active now playing session
    var hasActiveNowPlayingSession: Bool {
        MediaControls.hasActiveNowPlayingSession(for: self)
    }
    
    func togglePictureInPicture() {
        let jsCode = """
        (async function() {
            function findMediaElement() {
                let video = document.querySelector('video');
                if (video) return video;
                
                let iframe = document.querySelector('iframe');
                if (iframe) {
                    try {
                        let innerDoc = iframe.contentDocument || iframe.contentWindow.document;
                        return innerDoc.querySelector('video');
                    } catch (e) {
                        console.error('No access to iframe content:', e);
                        return null;
                    }
                }
                return null;
            }

            let mediaElement = findMediaElement();
            if (mediaElement && document.pictureInPictureEnabled && !mediaElement.paused && !mediaElement.ended) {
                if (!document.pictureInPictureElement) {
                    await mediaElement.requestPictureInPicture();
                } else {
                    await document.exitPictureInPicture();
                }
            } else {
                console.error('No media element found or PiP not supported.');
            }
        })();
        """

        evaluateJavaScript(jsCode)
    }
    
    weak var currentNSSavePanel: NSSavePanel?
}
