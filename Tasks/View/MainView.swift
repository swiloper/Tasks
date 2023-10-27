//
//  MainView.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @State private var tasks: [Task] = []
    
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
        } //: NavigationStack
    }
    
    // MARK: - Empty
    
    private var empty: some View {
        ContentUnavailableView("Empty List", systemImage: "checklist", description: Text("Create new tasks and achieve your goals."))
    }
    
    // MARK: - List
    
    private var list: some View {
        List {
            ForEach($tasks) { $task in
                TaskRowView(item: $task)
            } //: ForEach
            .onMove { from, to in
                tasks.move(fromOffsets: from, toOffset: to)
            }
            .onDelete { at in
                tasks.remove(atOffsets: at)
            }
        } //: List
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
    
    // MARK: - Plus
    
    private var plus: some View {
        Button {
            tasks.insert(Task(), at: .zero)
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.blue)
                .padding(16)
        } //: Button
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Tasks") {
    MainView()
}
