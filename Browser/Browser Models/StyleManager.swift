//
//  StyleManager.swift
//  Browser
//
//  Created by Browser on 10/8/25.
//

import Foundation
import SwiftUI

/// Manages website-specific CSS themes from the Styles directory
@Observable
class StyleManager {
    /// Shared singleton instance
    static let shared = StyleManager()
    
    /// Dictionary mapping domain names to their CSS content
    private(set) var styleCache: [String: String] = [:]
    
    /// Fallback CSS content from example.com.css
    private(set) var fallbackStyle: String = ""
    
    /// Path to the Resources directory where CSS files are stored
    private var stylesDirectoryURL: URL {
        guard let resourcePath = Bundle.main.resourcePath else {
            return URL(fileURLWithPath: "")
        }
        return URL(fileURLWithPath: resourcePath)
    }
    
    private init() {
        scanStyles()
    }
    
    /// Scans the Resources directory and loads all CSS files into cache
    func scanStyles() {
        styleCache.removeAll()
        fallbackStyle = ""
        
        let fileManager = FileManager.default
        
        print("🎨 Scanning Resources directory: \(stylesDirectoryURL.path)")
        
        guard fileManager.fileExists(atPath: stylesDirectoryURL.path) else {
            print("⚠️ Resources directory not found at: \(stylesDirectoryURL.path)")
            print("⚠️ Bundle.main.resourcePath: \(Bundle.main.resourcePath ?? "nil")")
            return
        }
        
        do {
            let files = try fileManager.contentsOfDirectory(at: stylesDirectoryURL, includingPropertiesForKeys: nil)
            let cssFiles = files.filter { $0.pathExtension.lowercased() == "css" }
            
            print("🎨 Found \(cssFiles.count) CSS file(s) in Resources directory")
            
            for file in cssFiles {
                let fileName = file.deletingPathExtension().lastPathComponent
                
                print("  📄 Processing: \(fileName).css")
                
                do {
                    let cssContent = try String(contentsOf: file, encoding: .utf8)
                    let processedCSS = processCSS(cssContent)
                    
                    if fileName == "example.com" {
                        fallbackStyle = processedCSS
                        print("  ✓ Loaded fallback style: \(fileName).css (\(processedCSS.count) chars)")
                    } else {
                        styleCache[fileName] = processedCSS
                        print("  ✓ Loaded style for domain: \(fileName) (\(processedCSS.count) chars)")
                    }
                } catch {
                    print("  ✗ Failed to read \(fileName).css: \(error.localizedDescription)")
                }
            }
            
            print("🎨 Style scanning complete. \(styleCache.count) domain(s) + fallback loaded")
            print("🎨 Available domains: \(styleCache.keys.sorted())")
            
        } catch {
            print("⚠️ Failed to scan Resources directory: \(error.localizedDescription)")
        }
    }
    
    /// Process CSS content by removing comments starting with @
    private func processCSS(_ css: String) -> String {
        let lines = css.components(separatedBy: .newlines)
        let processedLines = lines.filter { line in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            // Skip lines that are comments starting with /* @
            return !trimmed.hasPrefix("/* @")
        }
        return processedLines.joined(separator: "\n")
    }
    
    /// Get CSS for a specific domain, or fallback if not found
    func getStyle(for url: URL) -> String? {
        guard let host = url.host else { return fallbackStyle }
        
        // Normalize domain by removing www. prefix for primary lookup
        let normalizedHost = host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
        
        print("🔍 Looking for style for host: \(host), normalized: \(normalizedHost)")
        print("🔍 Available cache keys: \(styleCache.keys.sorted())")
        
        // Primary: Try normalized version (this matches youtube.com.css for www.youtube.com)
        if let style = styleCache[normalizedHost] {
            print("🎨 Using custom style for: \(normalizedHost)")
            return style
        }
        
        // Secondary: Try exact match with original host (in case someone has www.youtube.com.css)
        if let style = styleCache[host] {
            print("🎨 Using custom style for: \(host)")
            return style
        }
        
        // Tertiary: Try adding www. prefix to normalized (if it was originally without www)
        if !host.hasPrefix("www.") {
            let withWWW = "www." + normalizedHost
            if let style = styleCache[withWWW] {
                print("🎨 Using custom style for: \(withWWW)")
                return style
            }
        }
        
        // Return fallback
        print("🎨 Using fallback style for: \(host)")
        return fallbackStyle
    }
    
    /// Check if styles are available (either domain-specific or fallback)
    var hasStyles: Bool {
        return !styleCache.isEmpty || !fallbackStyle.isEmpty
    }
}
