//
//  TodoItemExtension.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import Foundation
import CoreData
import SwiftUI

// Extension to make Item work with our app
extension Item {
    // Stored properties for our model
    private static let titleKey = "title_key"
    private static let isCompletedKey = "isCompleted_key"
    private static let priorityKey = "priority_key"
    private static let dueDateKey = "dueDate_key"
    private static let isRecurringKey = "isRecurring_key"
    private static let recurrenceFrequencyKey = "recurrenceFrequency_key"
    private static let dueTimeKey = "dueTime_key"
    
    // Recurrence frequency options
    enum RecurrenceFrequency: String, CaseIterable, Identifiable, Codable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var id: String { self.rawValue }
        
        var calendarComponent: Calendar.Component {
            switch self {
            case .daily: return .day
            case .weekly: return .weekOfYear
            case .monthly: return .month
            case .yearly: return .year
            }
        }
        
        var interval: Int {
            switch self {
            case .daily, .weekly, .monthly, .yearly: return 1
            }
        }
    }
    
    // Computed properties with getters and setters
    var title: String {
        get {
            // Try to get stored value first
            if let storedTitle = UserDefaults.standard.string(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.titleKey)") {
                return storedTitle
            }
            // Fallback to timestamp
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return "Task created: " + (formatter.string(from: timestamp ?? Date()))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.titleKey)")
        }
    }
    
    var isCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.isCompletedKey)")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.isCompletedKey)")
        }
    }
    
    var priorityEnum: Priority {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.priorityKey)")
            // Use the fromRawIndex static method to convert Int to Priority
            return Priority.fromRawIndex(Int16(rawValue))
        }
        set {
            UserDefaults.standard.set(Int(newValue.rawIndex), forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.priorityKey)")
        }
    }
    
    var dueDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.dueDateKey)") as? Date
        }
        set {
            if let newDate = newValue {
                UserDefaults.standard.set(newDate, forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.dueDateKey)")
            } else {
                UserDefaults.standard.removeObject(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.dueDateKey)")
            }
        }
    }
    
    // Combined due date and time
    var dueDateTime: Date? {
        get {
            guard let dueDate = dueDate else { return nil }
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: dueDate)
            
            if let dueTime = dueTime {
                let timeComponents = calendar.dateComponents([.hour, .minute], from: dueTime)
                components.hour = timeComponents.hour
                components.minute = timeComponents.minute
            } else {
                // Default to 9:00 AM if no time is set
                components.hour = 9
                components.minute = 0
            }
            
            return calendar.date(from: components)
        }
        set {
            guard let date = newValue else {
                dueDate = nil
                return
            }
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            dueDate = calendar.date(from: dateComponents)
            
            // Extract and store the time component
            let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
            if let timeDate = calendar.date(from: timeComponents) {
                dueTime = timeDate
            }
        }
    }
    
    var dueTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.dueTimeKey)") as? Date
        }
        set {
            if let newTime = newValue {
                UserDefaults.standard.set(newTime, forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.dueTimeKey)")
                
                // Update the due date with the new time if a due date exists
                if let existingDate = dueDate {
                    let calendar = Calendar.current
                    var components = calendar.dateComponents([.year, .month, .day], from: existingDate)
                    let timeComponents = calendar.dateComponents([.hour, .minute], from: newTime)
                    components.hour = timeComponents.hour
                    components.minute = timeComponents.minute
                    
                    if let newDateTime = calendar.date(from: components) {
                        dueDate = newDateTime
                    }
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.dueTimeKey)")
            }
        }
    }
    
    var isOverdue: Bool {
        if let dueDateTime = dueDateTime, !isCompleted {
            return dueDateTime < Date()
        }
        return false
    }
    
    var isRecurring: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.isRecurringKey)")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.isRecurringKey)")
        }
    }
    
    var recurrenceFrequency: RecurrenceFrequency {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.recurrenceFrequencyKey)"),
               let frequency = RecurrenceFrequency(rawValue: rawValue) {
                return frequency
            }
            return .weekly // Default to weekly if not set
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "\(objectID.uriRepresentation().absoluteString)_\(Item.recurrenceFrequencyKey)")
        }
    }
    
    // Calculate the next due date for recurring tasks
    func nextDueDate() -> Date? {
        guard isRecurring, let dueDate = dueDate else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        
        // If the due date is in the future, return it
        if dueDate > now {
            return dueDate
        }
        
        // Calculate the next occurrence
        var nextDate = dueDate
        let frequency = recurrenceFrequency
        
        while nextDate <= now {
            if let date = calendar.date(byAdding: frequency.calendarComponent, 
                                       value: frequency.interval, 
                                       to: nextDate) {
                nextDate = date
            } else {
                break
            }
        }
        
        return nextDate
    }
    
    // Create a new item with timestamp
    static func createBasicItem(in context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error creating item: \(nsError), \(nsError.userInfo)")
        }
        
        return newItem
    }
    
    // Toggle completion status
    func toggleCompletion(in context: NSManagedObjectContext) -> String {
        isCompleted.toggle()
        
        // If it's a recurring task and we're marking it complete, update the due date
        if isCompleted && isRecurring {
            if let nextDate = nextDueDate() {
                dueDate = nextDate
                isCompleted = false // Reset completion for the next occurrence
            }
        }
        
        // Save the changes
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error toggling completion: \(nsError), \(nsError.userInfo)")
        }
        
        return self.title
    }
    
    // Delete this item
    func delete(in context: NSManagedObjectContext) {
        context.delete(self)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error deleting item: \(nsError), \(nsError.userInfo)")
        }
    }
}
