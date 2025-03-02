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
    @Environment(\.colorScheme) var colorScheme
    @Environment(BrowserWindowState.self) var browserWindowState
    
    @Query(sort: \BrowserHistoryEntry.date, order: .reverse) var history: [BrowserHistoryEntry]
    var groupedHistory: [Date: [BrowserHistoryEntry]] {
        Dictionary(grouping: history) { entry in
            let date = Calendar.current.startOfDay(for: entry.date)
            return date
        }
    }
    
    @Bindable var browserTab: BrowserTab
    
    @State var selectedHistoryEntries = Set<BrowserHistoryEntry>()
    
    var body: some View {
        Group {
            if history.isEmpty {
                ContentUnavailableView("Start Navigating To Fill The History", systemImage: "clock.arrow.circlepath")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List(selection: $selectedHistoryEntries) {
                    Button("Clear History") {
                        BrowserHistoryEntry.deleteAllHistory(using: modelContext)
                    }
                    
                    ForEach(groupedHistory.keys.sorted { $1 < $0 }, id: \.self) { date in
                        Section {
                            ForEach(groupedHistory[date] ?? []) { entry in
                                HistoryEntryRow(entry: entry)
                                    .modifier(HistoryEntryRowContextMenu(entry: entry, browserTab: browserTab))
                            }
                        } header: {
                            Text(date, style: .date)
                                .font(.title.bold())
                                .contextMenu {
                                    Button("Delete Entries From This Date") {
                                        for entry in groupedHistory[date] ?? [] {
                                            modelContext.delete(entry)
                                        }
                                        try? modelContext.save()
                                    }
                                }
                        }
                        .collapsible(true)
                        .headerProminence(.increased)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.sidebar)
            }
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
