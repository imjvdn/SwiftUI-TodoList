//
//  TodoItemExtension.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import Foundation
import CoreData

/*
 IMPORTANT: This file contains extensions for the CoreData Item entity.
 These extensions will work once you've properly set up the CoreData model.

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

extension Item {
    // This extension will be used after the CoreData model is set up
    
    // For now, we'll provide a simplified version that works with the default model
    
    // Create a new item with just a timestamp (for now)
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
    
    /*
     The following methods will be available after you set up the CoreData model.
     They are commented out to avoid compilation errors.
     
    // Computed property to check if task is overdue
    var isOverdue: Bool {
        if let dueDate = dueDate, !isCompleted {
            return dueDate < Date()
        }
        return false
    }
    
    // Computed property to get the priority as enum
    var priorityEnum: Priority {
        return Priority.fromRawIndex(priority)
    }
    
    // Convenience method to set the priority from enum
    func setPriority(_ priorityEnum: Priority) {
        self.priority = priorityEnum.rawIndex
    }
    
    // Create a new todo item with all properties
    static func createItem(title: String, priority: Priority = .medium, dueDate: Date? = nil, in context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.id = UUID()
        newItem.title = title
        newItem.timestamp = Date()
        newItem.isCompleted = false
        newItem.priority = priority.rawIndex
        newItem.dueDate = dueDate
        
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
        self.isCompleted.toggle()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error toggling completion: \(nsError), \(nsError.userInfo)")
        }
        
        return self.title ?? ""
    }
    
    // Update priority
    func updatePriority(to priority: Priority, in context: NSManagedObjectContext) {
        self.priority = priority.rawIndex
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error updating priority: \(nsError), \(nsError.userInfo)")
        }
    }
    
    // Update due date
    func updateDueDate(to dueDate: Date?, in context: NSManagedObjectContext) {
        self.dueDate = dueDate
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error updating due date: \(nsError), \(nsError.userInfo)")
        }
    }
    */
}
