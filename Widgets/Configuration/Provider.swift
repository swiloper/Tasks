//
//  Provider.swift
//  Widgets
//
//  Created by Ihor Myronishyn on 08.02.2024.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    // MARK: - Placeholder
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: .now)
    }
    
    // MARK: - Snapshot

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(Entry(date: .now))
    }
    
    // MARK: - Timeline

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [Entry(date: .now)], policy: .atEnd))
    }
}
