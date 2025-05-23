//
//  TodoListApp.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI

@main
struct TodoListApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var settingsManager = SettingsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settingsManager)
        }
    }
}
