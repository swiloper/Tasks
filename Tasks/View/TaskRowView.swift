//
//  TaskRowView.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.order) private var tasks: [Task]

    @Bindable var item: Task
    
    private let inset: CGFloat = 8
    
    // MARK: - Complete
    
    private func complete() {
        item.isCompleted.toggle()
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        var temp = tasks
        temp = temp.sorted(by: { !$0.isCompleted && $1.isCompleted })
        
        DispatchQueue.main.schedule(after: .init(.now() + 0.25)) {
            update(temp)
        }
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
        HStack(spacing: .zero) {
            checkmark
            field
        } //: HStack
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: .zero, leading: inset, bottom: .zero, trailing: inset))
    }
    
    // MARK: - Checkmark
    
    private var checkmark: some View {
        Button {
            complete()
        } label: {
            let side: CGFloat = 44
            
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: side, height: side)
        } //: Button
        .buttonStyle(.plain)
        .animation(.bouncy, value: item.isCompleted)
    }
    
    // MARK: - Field
    
    private var field: some View {
        TextField("Title", text: $item.title)
    }
}

// MARK: - Preview

#Preview("Row") {
    TaskRowView(item: Task(order: .zero))
}
