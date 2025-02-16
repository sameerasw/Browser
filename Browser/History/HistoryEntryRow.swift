//
//  HistoryEntryView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/16/25.
//

import SwiftUI

struct HistoryEntryView: View {
    let entry: BrowserHistoryEntry
    var body: some View {
        HStack {
            Group {
                if let favicon = entry.favicon, let nsImage = NSImage(data: favicon) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "globe")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 16, height: 16)
            .clipShape(.rect(cornerRadius: 4))
            
            Text(entry.title)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}
