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
    
    var isOverdue: Bool {
        if let dueDate = dueDate, !isCompleted {
            return dueDate < Date()
        }
        return false
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
    
    // Toggle completion status (simulated)
    func toggleCompletion(in context: NSManagedObjectContext) -> String {
        // In the real implementation, we would toggle isCompleted
        // For now, we just return the title
        
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
