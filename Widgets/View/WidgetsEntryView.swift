//
//  WidgetsEntryView.swift
//  Widgets
//
//  Created by Ihor Myronishyn on 08.02.2024.
//

import SwiftUI
import SwiftData

struct WidgetsEntryView: View {
    
    // MARK: - Properties
    
    var entry: Provider.Entry
    @Query(sort: \Task.order) private var tasks: [Task]
    
    // MARK: - Body

    var body: some View {
        VStack {
            ForEach(tasks.prefix(3)) { task in
                HStack {
                    Button(intent: CompleteTaskIntent(id: task.id)) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(task.isCompleted ? .white : .blue, .blue)
                    } //: Button
                    .buttonStyle(.plain)
                    
                    Text(task.title)
                        .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                    
                    Spacer(minLength: .zero)
                } //: HStack
            } //: ForEach
        } //: VStack
    }
}

// MARK: - Preview

#Preview {
    WidgetsEntryView(entry: Entry(date: .now))
}
