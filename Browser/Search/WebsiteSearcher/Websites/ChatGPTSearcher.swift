//
//  ChatGPTSearcher.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/9/25.
//

import SwiftUI

struct ChatGPTSearcher: WebsiteSearcher {
    var title = "ChatGPT"
    var color = Color(hex: "#74AA9C")!
        
    func itemURL(for query: String) -> URL {
        URL(string: "https://chatgpt.com/?q=\(query)")!
    }
}
