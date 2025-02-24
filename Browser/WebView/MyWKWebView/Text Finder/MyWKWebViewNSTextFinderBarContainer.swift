//
//  MyWKWebViewNSTextFinderBarContainer.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/23/25.
//

import WebKit

extension MyWKWebView: NSTextFinderBarContainer {
    
    func triggerTextFinderAction(_ action: NSTextFinder.Action) {
        textFinder.performAction(action)
    }
    
    @objc func toggleTextFinder() {
        textFinder.performAction(isFindBarVisible ? .hideFindInterface : .showFindInterface)
    }
    
    var findBarView: NSView? {
        get {
            textFindBarView
        }
        set(findBarView) {
            textFindBarView = findBarView
            textFindBarView?.autoresizingMask = [.maxYMargin, .width]
            textFindBarView?.frame = NSMakeRect(0, 0, bounds.size.width, textFindBarView!.frame.size.height)
            isFindBarVisible = true
        }
    }
    
    var isFindBarVisible: Bool {
        get {
            textFindBarVisible
        }
        set(findBarVisible) {
            textFindBarVisible = findBarVisible
            if findBarVisible, let textFindBarView {
                addSubview(textFindBarView)
            } else {
                textFindBarView?.removeFromSuperview()
            }
        }
    }
        
    func findBarViewDidChangeHeight() {}
}
