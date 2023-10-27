//
//  TaskRowView.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI

struct TaskRowView: View {
    
    // MARK: - Properties

    @Binding var item: Task
    
    @State private var text: String = .empty
    
    private let inset: CGFloat = 8
    private let side: CGFloat = 28
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: .zero) {
            checkmark
            field
        } //: HStack
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: .zero, leading: inset, bottom: .zero, trailing: inset))
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading, side + inset * 2)
        }
    }
    
    // MARK: - Checkmark
    
    private var checkmark: some View {
        Button {
            item.isCompleted.toggle()
        } label: {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: side, height: side)
                .padding(inset)
                .animation(.spring, value: item.isCompleted)
        } //: Button
        .buttonStyle(.plain)
    }
    
    // MARK: - Field
    
    private var field: some View {
        TextField("Title", text: $text)
    }
}

// MARK: - Preview

#Preview("Row") {
    TaskRowView(item: .constant(Task()))
}
