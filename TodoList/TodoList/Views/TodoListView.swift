//
//  TodoListView.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI
import CoreData

/*
 IMPORTANT: This is a simplified version of the TodoListView that works with the default CoreData model.
 Once you've set up the CoreData model with all the required attributes, you can uncomment the full implementation.

 To set up the CoreData model:
 1. Open the TodoList.xcdatamodeld file in Xcode
 2. Select the "Item" entity and add these attributes:
    - id: UUID (Optional)
    - title: String
    - isCompleted: Boolean (Use scalar type)
    - priority: Integer 16 (Use scalar type)
    - dueDate: Date (Optional)
    - Keep the existing "timestamp" attribute
 3. Save and build the project
*/

struct TodoListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @StateObject private var settingsManager = SettingsManager()
    
    // These states will be used in the full implementation
    // @State private var newItemTitle = ""
    // @State private var selectedPriority: Priority = .medium
    // @State private var selectedDueDate: Date = Date().addingTimeInterval(24 * 60 * 60)
    // @State private var isDueDateEnabled = false
    // @State private var showNotification = false
    // @State private var notificationMessage = ""
    // @State private var notificationIcon = ""
    // @State private var notificationColor = Color.green
    
    var body: some View {
        NavigationView {
            // Simplified view that works with the default CoreData model
            VStack {
                Text("Todo List App")
                    .font(.title)
                    .padding()
                
                Text("To use the full app features:")
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Open the TodoList.xcdatamodeld file")
                    Text("2. Add the required attributes to the Item entity")
                    Text("3. Save and rebuild the project")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding()
                
                // Display existing items with timestamp
                List {
                    ForEach(items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Item")
                                    .font(.headline)
                                
                                if let timestamp = item.timestamp {
                                    Text("Created: \(timestamp, formatter: itemFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            // Simple delete button
                            Button(action: {
                                deleteItem(item)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteItems)
                }
                
                // Simple add button
                Button(action: {
                    addBasicItem()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Sample Item")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                    
            }
            .navigationTitle("Todo List Setup")
            .toolbar(content: { // Explicitly specify the toolbar type
                ToolbarItem(placement: .navigationBarLeading) {
                    // Theme toggle menu
                    Menu {
                        Button(action: {
                            settingsManager.colorTheme = .light
                        }) {
                            Label("Light Mode", systemImage: "sun.max")
                        }
                        
                        Button(action: {
                            settingsManager.colorTheme = .dark
                        }) {
                            Label("Dark Mode", systemImage: "moon")
                        }
                        
                        Button(action: {
                            settingsManager.colorTheme = .system
                        }) {
                            Label("System Default", systemImage: "gear")
                        }
                    } label: {
                        Image(systemName: "circle.lefthalf.filled")
                    }
                }
            })
        }
        // Apply the color scheme preference
        .preferredColorScheme(settingsManager.colorTheme.effectiveColorScheme(systemScheme: colorScheme))
    }
    
    // Function to add a basic item with just a timestamp
    private func addBasicItem() {
        withAnimation {
            _ = Item.createBasicItem(in: viewContext)
        }
    }
    
    // Delete a specific item
    private func deleteItem(_ item: Item) {
        withAnimation {
            viewContext.delete(item)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error deleting item: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Delete items at specified offsets
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error deleting items: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
