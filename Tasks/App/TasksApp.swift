//
//  TasksApp.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 26.10.2023.
//

import SwiftUI
import SwiftData

@main
struct TasksApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        } //: WindowGroup
        .modelContainer(for: Task.self)
    }
}
