//
//  ContentView.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TodoListView()
    }
}

// Formatter for displaying dates
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
