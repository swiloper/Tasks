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
            .red
        case .orange:
            .orange
        case .yellow:
            .yellow
        case .green:
            .green
        case .blue:
            .blue
        case .purple:
            .purple
        case .indigo:
            .indigo
        }
    }
    
    @available(iOSApplicationExtension, unavailable)
    var icon: Icon {
        Icon(light: "Light" + name, dark: "Dark" + name)
    }
}
