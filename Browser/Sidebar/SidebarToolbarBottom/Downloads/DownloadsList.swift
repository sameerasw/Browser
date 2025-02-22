//
//  DownloadsList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/22/25.
//

import SwiftUI

struct DownloadsList: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    
    @State private var downloads: [Download] = []
    
    var body: some View {
        LazyVStack {
            ForEach(downloads) { download in
                DownloadRow(download: download)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onAppear {
            guard let downloadURL = userPreferences.downloadURL, downloadURL.startAccessingSecurityScopedResource() else { return }
            
            do {
                let downloads = try FileManager.default.contentsOfDirectory(at: downloadURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .producesRelativePathURLs])
                
                // Sort by date
                self.downloads = downloads
                    .sorted {
                        let resourceValues1 = try? $0.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                        let resourceValues2 = try? $1.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                        
                        // Take the most recent date
                        let date1 = max(resourceValues1?.creationDate ?? .distantPast, resourceValues1?.contentModificationDate ?? .distantPast)
                        let date2 = max(resourceValues2?.creationDate ?? .distantPast, resourceValues2?.contentModificationDate ?? .distantPast)
                                                
                        return date1 > date2
                    }
                    .prefix(5)
                    .map { Download(url: $0) }
                    .reversed()
            } catch {
                print("Failed to get downloads: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    DownloadsList()
}
