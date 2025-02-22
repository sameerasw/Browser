//
//  Download.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/22/25.
//

import SwiftUI
import WebKit

struct Download: Identifiable {
    let url: URL
    let name: String
    let wkDownload: WKDownload?
    
    init(url: URL, wkDownload: WKDownload? = nil) {
        self.url = url
        self.name = url.lastPathComponent
        self.wkDownload = wkDownload
    }
    
    var isDownloading: Bool {
        wkDownload != nil || url.lastPathComponent.hasSuffix("browserDownload")
    }
    
    var id: URL { url }
}
