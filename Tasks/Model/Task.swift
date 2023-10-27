//
//  Task.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import Foundation

final class Task: Identifiable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    var isCompleted: Bool
    
    // MARK: - Init
    
    init(id: String = UUID().uuidString, title: String = .empty, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
