//
//  TaskRowView.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TaskRowView: View {
    
    // MARK: - Properties
    
    @Environment(\.scenePhase) private var phase
    @Environment(\.modelContext) private var context
    @AppStorage("theme", store: UserDefaults(suiteName: "group.tasks.storage")) private var theme: Theme = .blue
    @Query(sort: \Task.order) private var tasks: [Task]
    
    @FocusState var focused: String?
    @Bindable var task: Task
    
    private let inset: CGFloat = 8
    
    // MARK: - Remove
    
    private func remove(condition: Bool = true) {
        if condition {
            context.delete(task)
        }
    }
    
    // MARK: - Complete
    
    private func complete() {
        task.isCompleted.toggle()
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: .zero) {
            checkmark
            field
        } //: HStack
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: .zero, leading: inset, bottom: .zero, trailing: inset))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            delete
        }
        .onSubmit {
            remove(condition: task.title.isEmpty)
        }
        .onChange(of: phase) {
            if $1 == .active {
                task.isCompleted = task.isCompleted
            } else {
                remove(condition: task.title.isEmpty)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    // MARK: - Checkmark
    
    private var checkmark: some View {
        Button {
            complete()
        } label: {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .symbolRenderingMode(.palette)
                .foregroundStyle(task.isCompleted ? .white : theme.color, theme.color)
                .animation(.bouncy, value: task.isCompleted)
                .padding(inset)
        } //: Button
        .buttonStyle(.plain)
    }
    
    // MARK: - Field
    
    private var field: some View {
        TextField("Title", text: $task.title)
            .focused($focused, equals: task.id)
    }
    
    // MARK: - Delete
    
    private var delete: some View {
        Button(role: .destructive) {
            remove()
        } label: {
            Image(systemName: "trash.fill")
        } //: Button
    }
}

// MARK: - Preview

#Preview("Row") {
    TaskRowView(task: Task(order: .zero))
}
