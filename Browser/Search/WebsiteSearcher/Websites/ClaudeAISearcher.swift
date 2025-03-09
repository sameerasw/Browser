//
//  ClaudeAISearcher.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/9/25.
//

import SwiftUI

/// Searcher for Claude AI
struct ClaudeAISearcher: WebsiteSearcher {
    var title = "ClaudeAI"
    var color = Color(hex: "#C7785A")!
    
    func itemURL(for query: String) -> URL {
        URL(string: "https://claude.ai/new?q=\(query)")!
    }
}
