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
    
    @AppStorage("isDarkModeEnabled", store: UserDefaults(suiteName: "group.tasks.storage")) private var isDarkModeEnabled: Bool = false
    
    let kind: String = "Widgets"
    
    // MARK: - Body

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
                .modelContainer(for: Task.self)
                .containerBackground(isDarkModeEnabled ? Color.dark : Color.light, for: .widget)
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
        } //: StaticConfiguration
        .configurationDisplayName("Pending")
        .description("Get quick access to your not finished reminders.")
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    Widgets()
} timeline: {
    Entry(date: .now)
}
