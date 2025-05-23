//
//  SettingsManager.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI
import Combine

class SettingsManager: ObservableObject {
    @Published var colorTheme: ColorTheme = .system {
        didSet {
            saveTheme()
        }
    }
    
    init() {
        self.colorTheme = loadTheme()
    }
    
    private func saveTheme() {
        if let encoded = try? JSONEncoder().encode(colorTheme) {
            UserDefaults.standard.set(encoded, forKey: "colorTheme")
        }
    }
    
    private func loadTheme() -> ColorTheme {
        if let themeData = UserDefaults.standard.data(forKey: "colorTheme"),
           let decodedTheme = try? JSONDecoder().decode(ColorTheme.self, from: themeData) {
            return decodedTheme
        }
        return .system
    }
}
