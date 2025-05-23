//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Jadan Morrow on 5/23/25.
//

import Testing
import CoreData
@testable import TodoList

struct TodoListTests {
    
    // Helper function to create an in-memory Core Data context for testing
    func createTestContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "TodoList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.viewContext
    }
    
    // Test Priority enum functionality
    @Test func testPriorityEnum() async throws {
        // Test high priority
        let highPriority = Priority.high
        #expect(highPriority.rawValue == "High")
        #expect(highPriority.icon == "exclamationmark.triangle.fill")
        #expect(highPriority.rawIndex == 0)
        
        // Test conversion from raw index
        #expect(Priority.fromRawIndex(0) == .high)
        #expect(Priority.fromRawIndex(1) == .medium)
        #expect(Priority.fromRawIndex(2) == .low)
        #expect(Priority.fromRawIndex(99) == .medium) // Default case
    }
    
    // Test ColorTheme enum functionality
    @Test func testColorTheme() async throws {
        // Test theme conversion
        #expect(ColorTheme.fromRawIndex(0) == .light)
        #expect(ColorTheme.fromRawIndex(1) == .dark)
        #expect(ColorTheme.fromRawIndex(2) == .system)
        #expect(ColorTheme.fromRawIndex(99) == .system) // Default case
    }
    
    // Test creating and manipulating todo items
    @Test func testTodoItemOperations() async throws {
        let context = createTestContext()
        
        // Create a new todo item
        let todo = Item.createItem(title: "Test Task", priority: .high, dueDate: Date(), in: context)
        
        // Test properties
        #expect(todo.title == "Test Task")
        #expect(todo.isCompleted == false)
        #expect(todo.priorityEnum == .high)
        #expect(todo.dueDate != nil)
        
        // Test toggling completion
        let title = todo.toggleCompletion(in: context)
        #expect(title == "Test Task")
        #expect(todo.isCompleted == true)
        
        // Test updating priority
        todo.updatePriority(to: .low, in: context)
        #expect(todo.priorityEnum == .low)
        
        // Test updating due date
        let tomorrow = Date().addingTimeInterval(24 * 60 * 60)
        todo.updateDueDate(to: tomorrow, in: context)
        #expect(todo.dueDate != nil)
        
        // Test overdue functionality
        let overdueTodo = Item.createItem(
            title: "Overdue Task", 
            priority: .high, 
            dueDate: Date().addingTimeInterval(-24 * 60 * 60), // Yesterday
            in: context
        )
        #expect(overdueTodo.isOverdue == true)
        
        // Test completed tasks are not overdue
        overdueTodo.toggleCompletion(in: context)
        #expect(overdueTodo.isOverdue == false)
    }
    
    // Test SettingsManager
    @Test func testSettingsManager() async throws {
        let settingsManager = SettingsManager()
        
        // Default should be system
        #expect(settingsManager.colorTheme == .system)
        
        // Test changing theme
        settingsManager.colorTheme = .dark
        #expect(settingsManager.colorTheme == .dark)
        
        // Create a new instance to test persistence
        let newSettingsManager = SettingsManager()
        #expect(newSettingsManager.colorTheme == .dark)
    }
}
