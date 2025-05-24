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
    // Request notification permission on appear
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("Notification permission granted")
                // Schedule notifications for existing items
                DispatchQueue.main.async {
                    NotificationManager.shared.scheduleNotifications(for: Array(items))
                }
            } else {
                print("Notification permission denied")
            }
        }
    }
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
    @State private var selectedDueTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = 9 // Default to 9:00 AM
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var isDueDateEnabled = false
    @State private var isRecurring = false
    @State private var recurrenceFrequency: Item.RecurrenceFrequency = .weekly
    @State private var showTimePicker = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationIcon = ""
    @State private var notificationColor = Color.green
    
    var body: some View {
        ZStack(alignment: .top) {
            // Top notification banner that slides down like a text message
            if showNotification {
                NotificationBanner(message: notificationMessage, icon: notificationIcon, color: notificationColor)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showNotification)
                    .onAppear {
                        // Auto-dismiss after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showNotification = false
                            }
                        }
                    }
                    .zIndex(100) // Ensure notification appears above other content
            }
            
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
                
                // Due date and time selector
                VStack(spacing: 12) {
                    // Due date toggle and picker
                    HStack {
                        Toggle("Set Due Date", isOn: $isDueDateEnabled)
                            .font(.subheadline)
                        
                        if isDueDateEnabled {
                            DatePicker("", selection: $selectedDueDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                            
                            // Time picker button
                            Button(action: {
                                showTimePicker.toggle()
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                    Text(formattedTime(selectedDueTime))
                                }
                                .font(.subheadline)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    // Time picker sheet
                    .sheet(isPresented: $showTimePicker) {
                        NavigationView {
                            VStack {
                                DatePicker("Reminder Time", selection: $selectedDueTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .padding()
                                
                                Spacer()
                            }
                            .navigationTitle("Set Reminder Time")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        showTimePicker = false
                                    }
                                }
                            }
                        }
                    }
                    
                    // Recurring options
                    if isDueDateEnabled {
                        VStack(spacing: 8) {
                            HStack {
                                Toggle("Recurring", isOn: $isRecurring)
                                    .font(.subheadline)
                                    .onChange(of: isRecurring) { oldValue, newValue in
                                        // Reset frequency when toggling recurrence
                                        if newValue {
                                            recurrenceFrequency = .weekly
                                        }
                                    }
                                
                                if isRecurring {
                                    Picker("", selection: $recurrenceFrequency) {
                                        ForEach(Item.RecurrenceFrequency.allCases) { frequency in
                                            Text(frequency.rawValue).tag(frequency)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .labelsHidden()
                                }
                            }
                        }
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
                                    
                                    // Due date and recurrence info if available
                                    if let dueDate = item.dueDate {
                                        HStack(spacing: 4) {
                                            Text(dueDate, formatter: itemFormatter)
                                            
                                            if item.isRecurring {
                                                Image(systemName: "repeat")
                                                    .font(.caption2)
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .font(.caption)
                                        .foregroundColor(item.isOverdue ? .red : .gray)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(InsetGroupedListStyle())
                
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
        }
        .preferredColorScheme(settingsManager.colorTheme.effectiveColorScheme(systemScheme: colorScheme))
        .onAppear {
            requestNotificationPermission()
        }
    }
    
    // Function to clear all tasks
    private func clearAllTasks() {
        withAnimation {
            // Remove all pending notifications
            NotificationManager.shared.removeAllNotifications()
            
            // Use the PersistenceController to delete all tasks
            PersistenceController.shared.deleteAllTasks()
            
            // Show notification
            notificationMessage = "All tasks cleared"
            notificationIcon = "trash"
            notificationColor = .blue
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showNotification = true
            }
        }
    }
    
    // Function to add a new item
    private func addItem() {
        withAnimation {
            let newItem = Item.createBasicItem(in: viewContext)
            
            // Set the title and other properties
            newItem.title = newItemTitle
            newItem.priorityEnum = selectedPriority
            if isDueDateEnabled {
                newItem.dueDate = selectedDueDate
                newItem.dueTime = selectedDueTime
                newItem.isRecurring = isRecurring
                if isRecurring {
                    newItem.recurrenceFrequency = recurrenceFrequency
                }
                
                // Schedule notification for the new item
                newItem.scheduleNotification()
            }
            
            // Show notification
            notificationMessage = "Added: \(newItemTitle)"
            notificationIcon = "plus.circle.fill"
            notificationColor = .blue
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showNotification = true
            }
            
            // Reset input fields
            newItemTitle = ""
            isDueDateEnabled = false
            isRecurring = false
            recurrenceFrequency = .weekly
            
            // Save the context
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Function to toggle item completion
    private func toggleItemCompletion(_ item: Item) {
        withAnimation {
            // Get the title before toggling
            let title = item.title
            
            // Toggle the completion status
            let wasCompleted = item.isCompleted
            item.isCompleted = !wasCompleted
            
            // Handle notifications
            if item.isCompleted {
                // Remove notification when marking as completed
                item.removeNotification()
                
                // Show completion notification
                notificationMessage = "Completed: \(title)"
                notificationIcon = "checkmark.circle.fill"
                notificationColor = .green
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showNotification = true
                }
                
                // If it's a recurring task, schedule the next occurrence
                if item.isRecurring, let nextDate = item.nextDueDate() {
                    // Preserve the time when setting the next due date
                    let calendar = Calendar.current
                    let timeComponents = calendar.dateComponents([.hour, .minute], from: item.dueTime ?? Date())
                    
                    var nextDateComponents = calendar.dateComponents([.year, .month, .day], from: nextDate)
                    nextDateComponents.hour = timeComponents.hour
                    nextDateComponents.minute = timeComponents.minute
                    
                    if let nextDateTime = calendar.date(from: nextDateComponents) {
                        item.dueDate = nextDateTime
                        item.dueTime = nextDateTime
                        item.isCompleted = false
                        item.scheduleNotification()
                    }
                }
            } else {
                // Reschedule notification when unmarking as completed
                if item.dueDate != nil {
                    item.scheduleNotification()
                }
            }
            
            // Save the changes
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error toggling completion: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Delete a specific item
    private func deleteItem(_ item: Item) {
        withAnimation {
            // Get the title before deleting
            let title = item.title
            
            // Remove any scheduled notifications
            item.removeNotification()
            
            // Delete the item
            viewContext.delete(item)
            
            do {
                try viewContext.save()
                
                // Show deletion notification
                notificationMessage = "Deleted: \(title)"
                notificationIcon = "trash.fill"
                notificationColor = .red
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showNotification = true
                }
            } catch {
                let nsError = error as NSError
                print("Error deleting item: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Delete items at specified offsets
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // Get the count of items being deleted
            let count = offsets.count
            
            // Remove notifications for all items being deleted
            offsets.map { items[$0] }.forEach { item in
                item.removeNotification()
                viewContext.delete(item)
            }
            
            do {
                try viewContext.save()
                
                // Show deletion notification
                let itemText = count == 1 ? "item" : "items"
                notificationMessage = "Deleted \(count) \(itemText)"
                notificationIcon = "trash.fill"
                notificationColor = .red
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showNotification = true
                }
            } catch {
                let nsError = error as NSError
                print("Error deleting items: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// Format time for display
private func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
}

// Import the itemFormatter from Formatters.swift
