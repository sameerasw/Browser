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
    private var isPageEditable: Bool = false

    /// The "Search With Google" action (passed from the WKWebViewController)
    var searchWebAction: ((String) -> Void)? = nil
    /// The "Open Link In New Tab" action (passed from the WKWebViewController)
    var openLinkInNewTabAction: ((URL) -> Void)? = nil
    /// Present an action alert from the WKWebView (passed from the WKWebViewController)
    var presentActionAlert: ((String, String) -> Void)? = nil

    var textFinder: NSTextFinder
    var textFindBarView: NSView?
    var textFindBarVisible: Bool = false

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        self.textFinder = NSTextFinder()
        super.init(frame: frame, configuration: configuration)

        textFinder.isIncrementalSearchingEnabled = true
        textFinder.incrementalSearchingShouldDimContentView = true
        textFinder.client = self
        textFinder.findBarContainer = self
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

    /// Toggles page edit mode using public JavaScript hooks
    func toggleEditable() {
        isPageEditable.toggle()
        let designMode = isPageEditable ? "on" : "off"
        let contentEditable = isPageEditable ? "true" : "false"
        let script = "document.designMode='\(designMode)'; document.body.contentEditable='\(contentEditable)';"
        evaluateJavaScript(script) { _, error in
            if let error {
                print("Error toggling page edit mode: \(error.localizedDescription)")
            }
        }
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

    func togglePictureInPicture() {
        guard let pictureInPictureScriptURL = Bundle.main.url(forResource: "TogglePictureInPicture", withExtension: "js"),
              let pictureInPictureScript = try? String(contentsOf: pictureInPictureScriptURL, encoding: .utf8) else { return }
        evaluateJavaScript(pictureInPictureScript)
    }

    //MARK: - Variables for Context Menus
    weak var currentNSSavePanel: NSSavePanel?
}
