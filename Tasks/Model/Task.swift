//
//  Task.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import Foundation
import SwiftData

@Model
final class Task: Identifiable {
     
    // MARK: - Properties
    
    let id: String
    var title: String
    var isCompleted: Bool
    var order: Int
    
    // MARK: - Init
    
    init(id: String = UUID().uuidString, title: String = .empty, isCompleted: Bool = false, order: Int) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.order = order
    }
}
