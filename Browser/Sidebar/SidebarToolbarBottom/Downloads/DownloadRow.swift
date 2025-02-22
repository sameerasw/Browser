//
//  DownloadRow.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/22/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DownloadRow: View {
    
    @Environment(SidebarModel.self) var sidebarModel: SidebarModel
    let download: Download
    
    @State var hover = false
    
    var body: some View {
        HStack {
            Group {
                if download.isDownloading {
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(nsImage: downloadNSImage())
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 45, height: 45)
            
            VStack(alignment: .leading) {
                Text(download.name)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 3)
        .background(sidebarModel.allowDownloadHover && hover ? .white.opacity(0.4) : .clear)
        .clipShape(.rect(cornerRadius: 10))
        .onHover { hover = $0 }
        .disabled(!sidebarModel.allowDownloadHover)
    }
    
    private func downloadNSImage() -> NSImage {
        let fallbackImage = NSWorkspace.shared.icon(for: download.url.fileType ?? .item)
        guard let bookmarkData = UserDefaults.standard.data(forKey: "download_location_bookmark") else {
            return fallbackImage
        }
        
        do {
            var isStale = false
            let downloadLocation = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
            if !isStale, downloadLocation.startAccessingSecurityScopedResource() {
                defer { downloadLocation.stopAccessingSecurityScopedResource() }
                
                if FileManager.default.fileExists(atPath: download.url.path) {
                    if download.url.isDirectory {
                        return NSWorkspace.shared.icon(for: .folder)
                    }
                    
                    if download.url.contains(.image) {
                        return NSImage(contentsOf: download.url) ?? fallbackImage
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return fallbackImage
    }
}
