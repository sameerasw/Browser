//
//  BingSearcher.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/8/25.
//

import SwiftUI

/// Searcher for Bing
struct BingSearcher: WebsiteSearcher {
    var title = "Bing"
        
    var color = Color(hex: "02B7E9")!
    
    func queryURL(for query: String) -> URL {
        URL(string: "https://www.bing.com/asjson.aspx?query=\(query)")!
    }
    
    func itemURL(for query: String) -> URL {
        URL(string: "https://www.bing.com/search?q=\(query)")!
    }
    
    func parseSearchSuggestions(from result: String) throws -> [SearchSuggestion] {
        let components = result.components(separatedBy: ",")
        guard !components.isEmpty else {
            print("🔍👓 Error parsing search suggestions. Empty components.")
            return []
        }
        
        let regex = try NSRegularExpression(pattern: #""(.*?)""#)
        
        let extractedStrings = components.flatMap { string -> [String] in
            let matches = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
            return matches.compactMap { match -> String? in
                if let range = Range(match.range(at: 1), in: string) {
                    let extracted = String(string[range])
                    return extracted.isEmpty ? nil :
                    // Process Unicode characters
                    extracted.applyingTransform(StringTransform("Hex-Any"), reverse: false) ?? extracted
                }
                return nil
            }
        }
        
        // Drop first suggestion because it's the same as the search text
        // Drop last one beacuse it's google:suggestrelevance
        return extractedStrings.dropFirst().dropLast().map {
            SearchSuggestion($0, itemURL: itemURL(for: $0))
        }
    }
}
