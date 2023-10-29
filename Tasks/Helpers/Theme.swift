//
//  Theme.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 29.10.2023.
//

import SwiftUI

enum Theme: String, Identifiable, CaseIterable {
    
    // MARK: - Properties
    
    case red, orange, yellow, green, blue, purple, indigo
    
    var id: String {
        rawValue
    }
    
    var name: String {
        rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .red:
            Color.red
        case .orange:
            Color.orange
        case .yellow:
            Color.yellow
        case .green:
            Color.green
        case .blue:
            Color.blue
        case .purple:
            Color.purple
        case .indigo:
            Color.indigo
        }
    }
    
    var icon: Icon {
        Icon(light: "Light" + name, dark: "Dark" + name)
    }
}
