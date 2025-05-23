//
//  ColorTheme.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI

enum ColorTheme: String, Codable {
    case light, dark, system
    
    // Get the current effective theme based on system settings
    func effectiveColorScheme(systemScheme: ColorScheme?) -> ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return systemScheme ?? .light
        }
    }
    
    // For CoreData storage as Int16
    var rawIndex: Int16 {
        switch self {
        case .light: return 0
        case .dark: return 1
        case .system: return 2
        }
    }
    
    // Convert from CoreData Int16 back to ColorTheme
    static func fromRawIndex(_ index: Int16) -> ColorTheme {
        switch index {
        case 0: return .light
        case 1: return .dark
        case 2: return .system
        default: return .system
        }
    }
}
