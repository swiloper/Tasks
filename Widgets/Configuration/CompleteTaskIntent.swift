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
        let descriptor = FetchDescriptor(predicate: #Predicate<Task> { $0.id == id })
        
        if let task = try context.fetch(descriptor).first {
            task.isCompleted = true
            try context.save()
        }
        
        return .result()
    }
}
