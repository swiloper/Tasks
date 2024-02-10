//
//  Widgets.swift
//  Widgets
//
//  Created by Ihor Myronishyn on 30.10.2023.
//

import SwiftUI
import WidgetKit

struct Widgets: Widget {
    
    // MARK: - Properties
    
    let kind: String = "Widgets"
    
    // MARK: - Body

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Task.self)
        } //: StaticConfiguration
        .configurationDisplayName("List")
        .description("Get quick access to your reminders.")
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    Widgets()
} timeline: {
    Entry(date: .now)
}
