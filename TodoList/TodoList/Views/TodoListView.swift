//
//  TodoListView.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI
import CoreData

// Import the Formatters.swift file
@_exported import struct Foundation.Date
@_exported import class Foundation.DateFormatter

struct TodoListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @StateObject private var settingsManager = SettingsManager()
    
    // States for the full implementation
    @State private var newItemTitle = ""
    @State private var selectedPriority: Priority = .medium
    @State private var selectedDueDate: Date = Date().addingTimeInterval(24 * 60 * 60)
    @State private var isDueDateEnabled = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationIcon = ""
    @State private var notificationColor = Color.green
    
    var body: some View {
        NavigationView {
            VStack {
                // Task input field
                HStack {
                    TextField("Add a new task", text: $newItemTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                    .disabled(newItemTitle.isEmpty)
                    .padding(.trailing)
                }
                
                // Priority selector
                HStack {
                    Text("Priority:")
                        .font(.subheadline)
                    
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Button(action: {
                            selectedPriority = priority
                        }) {
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundColor(priority.color)
                                Text(priority.rawValue)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                selectedPriority == priority ?
                                priority.color.opacity(0.2) : Color.clear
                            )
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Due date selector
                HStack {
                    Toggle("Set Due Date", isOn: $isDueDateEnabled)
                        .font(.subheadline)
                    
                    if isDueDateEnabled {
                        DatePicker("", selection: $selectedDueDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                }
                .padding(.horizontal)
                
                // Task list
                List {
                    ForEach(items, id: \.objectID) { item in
                        HStack {
                            // Completion checkbox
                            Button(action: {
                                toggleItemCompletion(item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                            }
                            
                            // Task details
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)
                                    .strikethrough(item.isCompleted)
                                    .foregroundColor(item.isCompleted ? .gray : .primary)
                                
                                HStack {
                                    // Priority indicator
                                    Image(systemName: item.priorityEnum.icon)
                                        .foregroundColor(item.priorityEnum.color)
                                    
                                    // Due date if available
                                    if let dueDate = item.dueDate {
                                        Text(dueDate, formatter: itemFormatter)
                                            .font(.caption)
                                            .foregroundColor(item.dueDate ?? Date() < Date() && !item.isCompleted ? .red : .gray)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            // Delete button
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
                .listStyle(InsetGroupedListStyle())
                
                // Notification banner
                if showNotification {
                    NotificationBanner(message: notificationMessage, icon: notificationIcon, color: notificationColor)
                        .onAppear {
                            // Auto-dismiss after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showNotification = false
                                }
                            }
                        }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearAllTasks) {
                        Label("Clear All", systemImage: "trash")
                    }
                }
            }
        }
        .preferredColorScheme(settingsManager.colorTheme.effectiveColorScheme(systemScheme: colorScheme))
    }
    
    // Function to clear all tasks
    private func clearAllTasks() {
        withAnimation {
            // Use the PersistenceController to delete all tasks
            PersistenceController.shared.deleteAllTasks()
            
            // Show notification
            notificationMessage = "All tasks cleared"
            notificationIcon = "trash"
            notificationColor = .blue
            showNotification = true
        }
    }
    
    // Function to add a new item
    private func addItem() {
        withAnimation {
            let newItem = Item.createBasicItem(in: viewContext)
            
            // Show notification
            notificationMessage = "Added: \(newItemTitle)"
            notificationIcon = "plus.circle.fill"
            notificationColor = .blue
            withAnimation {
                showNotification = true
            }
            
            // Reset input fields
            newItemTitle = ""
        }
    }
    
    // Function to toggle item completion
    private func toggleItemCompletion(_ item: Item) {
        withAnimation {
            // Toggle completion and save
            let title = item.title
            
            if !item.isCompleted {
                // Show completion notification
                notificationMessage = "Completed: \(title)"
                notificationIcon = "checkmark.circle.fill"
                notificationColor = .green
                withAnimation {
                    showNotification = true
                }
            }
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

// Import the itemFormatter from Formatters.swift
