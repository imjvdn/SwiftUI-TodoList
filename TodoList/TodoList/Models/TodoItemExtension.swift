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
    // Computed properties to simulate the full model
    var title: String {
        // Use the timestamp as a title if no title attribute exists
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "Task created: " + (formatter.string(from: timestamp ?? Date()))
    }
    
    var isCompleted: Bool {
        // Default to false since we don't have this attribute yet
        return false
    }
    
    var priorityEnum: Priority {
        // Default to medium priority
        return .medium
    }
    
    var dueDate: Date? {
        // Use timestamp as due date for demo purposes
        return timestamp?.addingTimeInterval(24 * 60 * 60) // 1 day after creation
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
