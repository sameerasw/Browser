//
//  HistoryEntryList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/16/25.
//

import SwiftUI
import SwiftData

struct HistoryEntryList: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(BrowserWindowState.self) var browserWindowState: BrowserWindowState
    
    @Query(sort: \BrowserHistoryEntry.date, order: .reverse) var history: [BrowserHistoryEntry]
    var groupedHistory: [Date: [BrowserHistoryEntry]] {
        Dictionary(grouping: history) { entry in
            let date = Calendar.current.startOfDay(for: entry.date)
            return date
        }
    }
    
    @Bindable var browserTab: BrowserTab
    
    @State var showClearHistoryAlert = false
    @State var selectedHistoryEntries = Set<BrowserHistoryEntry>()
    
    var body: some View {
        Group {
            if history.isEmpty {
                ContentUnavailableView("Start Navigating To Fill The History", systemImage: "clock.arrow.circlepath")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List(selection: $selectedHistoryEntries) {
                    Button("Clear History") {
                        showClearHistoryAlert.toggle()
                    }
                    
                    ForEach(groupedHistory.keys.sorted(), id: \.self) { date in
                        Section {
                            ForEach(groupedHistory[date] ?? []) { entry in
                                EntryRow(entry: entry)
                            }
                        } header: {
                            Text(date, style: .date)
                                .font(.title.bold())
                        }
                        .collapsible(true)
                        .headerProminence(.increased)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.sidebar)
            }
        }
        .alert("Clear History", isPresented: $showClearHistoryAlert) {
            Button("Cancel", role: .cancel, action: {})
            Button("Clear", role: .destructive) {
                do {
                    try withAnimation(.browserDefault) {
                        try modelContext.delete(model: BrowserHistoryEntry.self)
                    }
                } catch {
                    print("Error deleting history: \(error.localizedDescription)")
                }
            }
        } message: {
            Text("Are you sure you want to clear your history? This action cannot be undone.")
        }
    }
    
    @ViewBuilder
    func EntryRow(entry: BrowserHistoryEntry) -> some View {
        HistoryEntryRow(entry: entry)
            .contextMenu {
                Button("Open") {
                    browserTab.title = entry.title
                    browserTab.url = entry.url
                    browserTab.favicon = entry.favicon
                    browserTab.type = .web
                }
                
                Button("Open in New Tab") {
                    if let currentSpace = browserWindowState.currentSpace {
                        currentSpace.openNewTab(BrowserTab(title: entry.title, favicon: entry.favicon, url: entry.url, order: browserTab.order + 1, browserSpace: currentSpace, type: .web), using: modelContext)
                    }
                }

                Divider()
                
                Button("Delete Entry") {
                    modelContext.delete(entry)
                    try? modelContext.save()
                }
            }
    }
}
