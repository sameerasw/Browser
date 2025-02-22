//
//  Settings View.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import SwiftUI

struct GeneralSettingsView: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    
    var body: some View {
        Form {
            Toggle("Close Selected Tab When Clearing Space", systemImage: "xmark.square", isOn: $userPreferences.clearSelectedTab)
            Toggle("Open Picture in Picture Automatically", systemImage: "inset.filled.topright.rectangle", isOn: $userPreferences.openPipOnTabChange)
            Toggle("Warn Before Quitting", systemImage: "exclamationmark.triangle", isOn: $userPreferences.warnBeforeQuitting)
            
            Section {
                HStack {
                    Label("File Download Location", systemImage: "arrowshape.down.circle")
                                        
                    Menu(content: {
                        if userPreferences.downloadLocationBookmark != nil {
                            Button {
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark")
                                    downloadLabel
                                }
                            }
                        }
                        
                        Button("Ask for each download") {
                            userPreferences.downloadLocationBookmark = nil
                        }
                        
                        Button("Choose...", action: userPreferences.chooseDownloadLocation)
                    }, label: {
                        downloadLabel
                    })
                }
            }
        }
        .formStyle(.grouped)
    }
    
    var downloadLabel: some View {
        Group {
            if let downloadLocation = userPreferences.downloadURL {
                Label {
                    Text(downloadLocation.path())
                } icon: {
                    if downloadLocation.hasDirectoryPath {
                        Image(nsImage: NSWorkspace.shared.icon(for: .folder))
                    } else {
                        Image(nsImage: NSWorkspace.shared.icon(forFile: downloadLocation.path()))
                    }
                }
            } else {
                Text("Ask for each download")
            }
        }
    }
}

#Preview {
    GeneralSettingsView()
}
