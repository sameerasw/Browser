//
//  NSImage.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/4/25.
//

import AppKit

// Helpers to convert NSImages to PNG data

fileprivate extension NSBitmapImageRep {
    var png: Data? {
        representation(using: .png, properties: [:])
    }
}

fileprivate extension Data {
    var bitmap: NSBitmapImageRep? {
        NSBitmapImageRep(data: self)
    }
}

extension NSImage {
    var pngData: Data? {
        tiffRepresentation?.bitmap?.png
    }
}
