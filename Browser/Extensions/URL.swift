//
//  URL.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import Foundation

extension URL {
    /// Returns the host of a URL
    /// - Example: `https://www.apple.com` returns `apple.com`
    var cleanHost: String {
        guard let host = self.host() else { return self.absoluteString }
        if host.contains("www") {
            return host.components(separatedBy: ".").dropFirst().joined(separator: ".")
        } else {
            return host
        }
    }
}

extension String {
    /// Detects if a string is a valid URL using a regular expression
    var isValidURL: Bool {
        do {
            let pattern = #"^((https?:\/\/)?(([\w-]+(?:\.[\w-]+)+)(:\d{1,5})?|([\w-]+:\d{1,5}))(\/\S*)?)$"#
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.utf16.count))
            return !results.isEmpty
        } catch {
            return false
        }
    }
    
    var startsWithHTTP: Bool {
        self.hasPrefix("http://") || self.hasPrefix("https://")
    }
}
