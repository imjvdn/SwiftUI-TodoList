//
//  Persistence.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample todo items for preview
        let titles = ["Buy groceries", "Finish project", "Call mom", "Pay bills", "Go for a run"]
        let priorities: [Priority] = [.high, .medium, .low, .medium, .high]
        
        // Create items with various states
        for i in 0..<titles.count {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        
        // First save the Core Data entities
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        // Now set our custom properties on the saved entities
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let items = try viewContext.fetch(fetchRequest)
            for (i, item) in items.enumerated() {
                if i < titles.count {
                    item.title = titles[i]
                    item.isCompleted = i % 2 == 0
                    item.priorityEnum = priorities[i]
                    
                    // Set due dates for some items
                    if i % 3 == 0 { // Every third item has a past due date
                        item.dueDate = Date().addingTimeInterval(-24 * 60 * 60) // Yesterday
                    } else if i % 3 == 1 { // Some have future due dates
                        item.dueDate = Date().addingTimeInterval(48 * 60 * 60) // Two days from now
                    }
                }
            }
        } catch {
            print("Error fetching items: \(error)")
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Method to clear all tasks from the CoreData store
    @MainActor
    func deleteAllTasks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
        } catch {
            print("Error deleting all tasks: \(error)")
        }
    }
}
