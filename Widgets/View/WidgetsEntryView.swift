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
    
    @Environment(\.colorScheme) private var scheme
    @Environment(\.widgetFamily) private var family
    @AppStorage("theme", store: UserDefaults(suiteName: "group.tasks.storage")) private var theme: Theme = .blue
    @Query(filter: #Predicate<Task> { !$0.isCompleted }, sort: \Task.order) private var tasks: [Task]
    
    var entry: Provider.Entry
    
    private let height: CGFloat = 20
    
    private var count: Int {
        switch family {
        case .systemSmall, .systemMedium:
            3
        default:
            10
        }
    }
    
    // MARK: - Body

    var body: some View {
        VStack {
            headline
            container(Array(tasks.prefix(count)))
        } //: VStack
    }
    
    // MARK: - Headline
    
    private var headline: some View {
        HStack {
            Image(systemName: "tray")
                .foregroundStyle(theme.color)
            Text("Pending")
            Spacer(minLength: .zero)
            Text("\(tasks.count)")
        } //: HStack
        .fontWeight(.semibold)
    }
    
    // MARK: - Container
    
    private func container(_ tasks: [Task]) -> some View {
        ZStack {
            if tasks.isEmpty {
                empty
            } else {
                list(tasks)
            }
        } //: ZStack
        .animation(.default, value: tasks.isEmpty)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white.opacity(scheme == .light ? 1 : 0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - Empty
    
    private var empty: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(theme.color.opacity(0.25))
    }
    
    // MARK: - List
    
    private func list(_ tasks: [Task]) -> some View {
        GeometryReader { proxy in
            let spacing: CGFloat = (proxy.size.height - CGFloat(count) * height) / CGFloat(count - 1)
            
            VStack(spacing: max(spacing, .zero)) {
                ForEach(tasks) {
                    row($0)
                } //: ForEach
            } //: VStack
            .frame(height: proxy.size.height, alignment: .top)
        } //: GeometryReader
        .frame(maxHeight: .infinity)
        .padding(8)
    }
    
    // MARK: - Row
    
    private func row(_ task: Task) -> some View {
        HStack(spacing: 6) {
            Button(intent: CompleteTaskIntent(id: task.id)) {
                Image(systemName: "circle")
                    .foregroundStyle(theme.color)
            } //: Button
            .buttonStyle(.plain)
            
            Text(task.title)
                .frame(maxWidth: .infinity, alignment: .leading)
        } //: HStack
        .frame(height: height)
    }
}

// MARK: - Preview

#Preview("Widgets") {
    WidgetsEntryView(entry: Entry(date: .now))
}
