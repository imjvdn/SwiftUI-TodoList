//
//  Priority.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI

enum Priority: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    // Colors that work in both light and dark mode
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
    
    // For CoreData storage as Int16
    var rawIndex: Int16 {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
    
    // Convert from CoreData Int16 back to Priority
    static func fromRawIndex(_ index: Int16) -> Priority {
        switch index {
        case 0: return .high
        case 1: return .medium
        case 2: return .low
        default: return .medium
        }
    }
}
