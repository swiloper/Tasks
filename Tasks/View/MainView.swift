//
//  MainView.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.order) private var tasks: [Task]
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @AppStorage("theme") private var theme: Theme = .blue
    @FocusState private var focused: String?
    
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
        .animation(.smooth, value: isDarkModeEnabled)
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
            let side: CGFloat = 44
            
            Image(systemName: "circle.inset.filled")
                .font(.headline)
                .foregroundStyle(theme.color)
                .frame(width: side, height: side)
        } //: Menu
        .onChange(of: theme) {
            $1.icon.change(isDark: isDarkModeEnabled)
        }
    }
    
    // MARK: - Switcher
    
    private var switcher: some View {
        Button {
            isDarkModeEnabled.toggle()
        } label: {
            let side: CGFloat = 44
            
            Image(systemName: isDarkModeEnabled ? "sun.max.fill" : "moon.fill")
                .font(.headline)
                .symbolEffect(.bounce, value: isDarkModeEnabled)
                .foregroundStyle(isDarkModeEnabled ? .yellow : .indigo)
                .frame(width: side, height: side)
        } //: Button
        .onChange(of: isDarkModeEnabled) {
            theme.icon.change(isDark: $1)
        }
    }
    
    // MARK: - Empty
    
    private var empty: some View {
        ContentUnavailableView("Empty List", systemImage: "checklist", description: Text("Create new tasks and achieve your goals."))
    }
    
    // MARK: - List
    
    private var list: some View {
        List {
            ForEach(tasks) { task in
                TaskRowView(item: task, focused: _focused)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            context.delete(task)
                        } label: {
                            Image(systemName: "trash.fill")
                        } //: Button
                    }
            } //: ForEach
            .onMove { from, to in
                var temp = tasks
                temp.move(fromOffsets: from, toOffset: to)
                update(temp)
            }
        } //: List
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .animation(.default, value: tasks)
    }
    
    // MARK: - Plus
    
    private var plus: some View {
        Button {
            let new = Task(order: tasks.count)
            context.insert(new)
            focused = new.id
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            Image(systemName: "plus.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, theme.color)
                .font(.largeTitle)
                .padding(16)
        } //: Button
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Tasks") {
    MainView()
}
