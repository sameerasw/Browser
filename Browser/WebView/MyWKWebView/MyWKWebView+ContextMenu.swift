//
//  MyWKWebView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import WebKit

/// Possible context menu types inside a WKWebView
enum ContextMenuType: String {
    case frame = "WKMenuItemIdentifierReload"
    case text = "WKMenuItemIdentifierTranslate"
    case link = "WKMenuItemIdentifierOpenLink"
    case image = "WKMenuItemIdentifierCopyImage"
    case media = "WKMenuItemIdentifierShowHideMediaControls"
    case unknown = "unknown"
}

/// Custom WKWebView subclass to handle context menus
class MyWKWebView: WKWebView {
    
    private let zoomFactors: [CGFloat] = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 4, 5, 6]
    var scaledZoomFactor: CGFloat? = nil
    
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
    
    /// Handle the context menu
    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        super.willOpenMenu(menu, with: event)
        
        // Detect menu type
        var contextMenuType: ContextMenuType = .unknown
        
        let menuItemsIdentifiers = menu.items.map { $0.identifier?.rawValue }
        
        for identifier in menuItemsIdentifiers {
            if let type = ContextMenuType(rawValue: identifier ?? "") {
                contextMenuType = type
                break
            }
        }
        
        switch contextMenuType {
        case .frame:
            handleFrameContextMenu(menu)
        default:
            break
        }
        
        if contextMenuType == .unknown {
            print("🖥️📚 Unknown context menu type with identifiers:", menuItemsIdentifiers)
        } else {
            print("🖥️📚 Context menu type: \(contextMenuType.rawValue)")
        }
    }
    
    weak var currentNSSavePanel: NSSavePanel?
}
