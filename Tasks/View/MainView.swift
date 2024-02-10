//
//  MainView.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI
import SwiftData
import WidgetKit

struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.order) private var tasks: [Task]
    @AppStorage("isDarkModeEnabled", store: UserDefaults(suiteName: "group.tasks.storage")) private var isDarkModeEnabled: Bool = false
    @AppStorage("theme", store: UserDefaults(suiteName: "group.tasks.storage")) private var theme: Theme = .blue
    @FocusState private var focused: String?
    
    private let inset: CGFloat = 8
    
    // MARK: - Personalize
    
    private func personalize() {
        theme.icon.change(isDark: isDarkModeEnabled)
    }
    
    // MARK: - Add
    
    private func add() {
        let task = Task(order: tasks.count)
        context.insert(task)
        focused = task.id
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    // MARK: - Update
    
    private func update(_ with: [Task]) {
        for order in with.indices {
            if let index = tasks.firstIndex(where: { with[order].id == $0.id }) {
                tasks[index].order = order
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                if tasks.isEmpty {
                    empty
                } else {
                    list
                }
            } //: ZStack
            .animation(.default, value: tasks.isEmpty)
            .navigationTitle("Tasks")
            .overlay(alignment: .bottomTrailing) {
                plus
            }
            .toolbar {
                toolbar
            }
        } //: NavigationStack
        .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
        .onChange(of: [theme.hashValue, isDarkModeEnabled.hashValue]) {
            personalize()
        }
    }
    
    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: .zero) {
                palette
                switcher
            } //: HStack
        } //: ToolbarItem
    }
    
    // MARK: - Palette
    
    private var palette: some View {
        Menu {
            Picker(String.empty, selection: $theme) {
                ForEach(Theme.allCases) {
                    Label($0.name, systemImage: "circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle($0.color)
                        .tag($0)
                } //: ForEach
            } //: Picker
        } label: {
            Image(systemName: "circle.inset.filled")
                .font(.headline)
                .foregroundStyle(theme.color)
                .padding(inset)
        } //: Menu
    }
    
    // MARK: - Switcher
    
    private var switcher: some View {
        Button {
            isDarkModeEnabled.toggle()
        } label: {
            Image(systemName: isDarkModeEnabled ? "sun.max.fill" : "moon.fill")
                .font(.headline)
                .symbolEffect(.bounce, value: isDarkModeEnabled)
                .foregroundStyle(isDarkModeEnabled ? .yellow : .indigo)
                .padding(inset)
        } //: Button
    }
    
    // MARK: - Empty
    
    private var empty: some View {
        ContentUnavailableView("Empty List", systemImage: "checklist", description: Text("Create new tasks and achieve your goals."))
    }
    
    // MARK: - List
    
    private var list: some View {
        List {
            ForEach(tasks) {
                TaskRowView(focused: _focused, task: $0)
                    .onChange(of: $0.isCompleted) {
                        var temp = tasks
                        temp = temp.sorted(by: { !$0.isCompleted && $1.isCompleted })
                        
                        DispatchQueue.main.schedule(after: .init(.now() + 0.25)) {
                            update(temp)
                        }
                    }
            } //: ForEach
            .onMove { from, to in
                var temp = tasks
                temp.move(fromOffsets: from, toOffset: to)
                update(temp)
            }
        } //: List
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .animation(.default, value: tasks)
    }
    
    // MARK: - Plus
    
    private var plus: some View {
        Button {
            add()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, theme.color)
                .padding(inset * 2)
        } //: Button
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Tasks") {
    MainView()
}
