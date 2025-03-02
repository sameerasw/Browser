//
//  NSImage.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/4/25.
//

import AppKit

extension NSImage {
    /// Convert an NSImage to PNG data
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation else { return nil }
        return NSBitmapImageRep(data: tiffRepresentation)?.representation(using: .png, properties: [:])
    }
}
