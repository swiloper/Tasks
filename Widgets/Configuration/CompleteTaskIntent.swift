//
//  CompleteTaskIntent.swift
//  Widgets
//
//  Created by Ihor Myronishyn on 08.02.2024.
//

import WidgetKit
import SwiftData
import AppIntents

struct CompleteTaskIntent: AppIntent {
    
    // MARK: - Properties
    
    static var title: LocalizedStringResource = "Complete Task Intent"
    
    @Parameter(title: "Task Identifier")
    var id: String
    
    // MARK: - Init
    
    init(id: String) {
        self.id = id
    }
    
    init() {
        // Nothing.
    }
    
    // MARK: - Perform
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let context = try ModelContext( ModelContainer(for: Task.self))
        let descriptor = FetchDescriptor(predicate: #Predicate<Task> { !$0.isCompleted }, sortBy: [SortDescriptor(\.order)])
        let tasks = try context.fetch(descriptor)
        
        if let completed = tasks.first(where: { $0.id == id }) {
            completed.isCompleted = true
            
            var temp = tasks
            temp = temp.sorted(by: { !$0.isCompleted && $1.isCompleted })
            
            for order in temp.indices {
                if let index = tasks.firstIndex(where: { temp[order].id == $0.id }) {
                    tasks[index].order = order
                }
            }
            
            try context.save()
        }
        
        return .result()
    }
}
