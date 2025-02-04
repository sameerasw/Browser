//
//  URL.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import Foundation

extension URL {
    /// Returns the host of a URL
    /// - Example: `https://www.apple.com` returns `www.apple.com`
    var cleanHost: String {
        guard let host = self.host() else { return self.absoluteString }
        return host.components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}
