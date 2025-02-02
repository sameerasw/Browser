//
//  URL.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/2/25.
//

import Foundation

extension URL {
    var cleanHost: String {
        guard let host = self.host() else { return self.absoluteString }
        return host.components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}
