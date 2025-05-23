import XCTest
import SwiftUI
@testable import PlaygroundSupport

// Test suite for the Todo List app
class TodoListTests: XCTestCase {
    
    // Test TodoItem model
    func testTodoItemModel() {
        // Create a todo item
        let dueDate = Date().addingTimeInterval(24 * 60 * 60) // Tomorrow
        let todo = TodoItem(id: UUID(), title: "Test Task", isCompleted: false, priority: .high, dueDate: dueDate)
        
        // Test properties
        XCTAssertEqual(todo.title, "Test Task")
        XCTAssertFalse(todo.isCompleted)
        XCTAssertEqual(todo.priority, Priority.high)
        XCTAssertNotNil(todo.dueDate)
        XCTAssertFalse(todo.isOverdue) // Should not be overdue since due date is tomorrow
    }
    
    // Test TodoStore functionality
    func testTodoStore() {
        let store = TodoStore()
        
        // Test adding a todo
        store.addTodo(title: "Test Task", priority: .medium)
        XCTAssertEqual(store.todoItems.count, 1)
        XCTAssertEqual(store.todoItems[0].title, "Test Task")
        XCTAssertEqual(store.todoItems[0].priority, .medium)
        
        // Test toggling completion
        let todoId = store.todoItems[0].id
        let title = store.toggleCompletion(for: store.todoItems[0])
        XCTAssertEqual(title, "Test Task")
        XCTAssertTrue(store.todoItems[0].isCompleted)
        
        // Test updating priority
        store.updatePriority(for: store.todoItems[0], to: .high)
        XCTAssertEqual(store.todoItems[0].priority, .high)
        
        // Test updating due date
        let tomorrow = Date().addingTimeInterval(24 * 60 * 60)
        store.updateDueDate(for: store.todoItems[0], to: tomorrow)
        XCTAssertNotNil(store.todoItems[0].dueDate)
        
        // Test deleting todos
        store.deleteTodos(at: IndexSet(integer: 0))
        XCTAssertEqual(store.todoItems.count, 0)
    }
    
    // Test ColorTheme functionality
    func testColorTheme() {
        // Test light theme
        let lightTheme = ColorTheme.light
        XCTAssertEqual(lightTheme.effectiveColorScheme(systemScheme: .dark), .light)
        
        // Test dark theme
        let darkTheme = ColorTheme.dark
        XCTAssertEqual(darkTheme.effectiveColorScheme(systemScheme: .light), .dark)
        
        // Test system theme
        let systemTheme = ColorTheme.system
        XCTAssertEqual(systemTheme.effectiveColorScheme(systemScheme: .light), .light)
        XCTAssertEqual(systemTheme.effectiveColorScheme(systemScheme: .dark), .dark)
        XCTAssertEqual(systemTheme.effectiveColorScheme(systemScheme: nil), .light) // Default to light if nil
    }
    
    // Test Priority enum
    func testPriorityEnum() {
        // Test high priority
        let highPriority = Priority.high
        XCTAssertEqual(highPriority.rawValue, "High")
        XCTAssertEqual(highPriority.color, .red)
        XCTAssertEqual(highPriority.icon, "exclamationmark.triangle.fill")
        
        // Test medium priority
        let mediumPriority = Priority.medium
        XCTAssertEqual(mediumPriority.rawValue, "Medium")
        XCTAssertEqual(mediumPriority.color, .orange)
        XCTAssertEqual(mediumPriority.icon, "exclamationmark.circle.fill")
        
        // Test low priority
        let lowPriority = Priority.low
        XCTAssertEqual(lowPriority.rawValue, "Low")
        XCTAssertEqual(lowPriority.color, .blue)
        XCTAssertEqual(lowPriority.icon, "info.circle.fill")
    }
    
    // Test overdue functionality
    func testOverdueFunctionality() {
        // Create a todo with past due date
        let pastDate = Date().addingTimeInterval(-24 * 60 * 60) // Yesterday
        let overdueTodo = TodoItem(id: UUID(), title: "Overdue Task", isCompleted: false, priority: .high, dueDate: pastDate)
        
        // Test overdue status
        XCTAssertTrue(overdueTodo.isOverdue)
        
        // Test completed tasks are not overdue even with past due date
        let completedOverdueTodo = TodoItem(id: UUID(), title: "Completed Overdue Task", isCompleted: true, priority: .high, dueDate: pastDate)
        XCTAssertFalse(completedOverdueTodo.isOverdue)
        
        // Test tasks without due date are not overdue
        let noDueDateTodo = TodoItem(id: UUID(), title: "No Due Date Task", isCompleted: false, priority: .medium)
        XCTAssertFalse(noDueDateTodo.isOverdue)
    }
    
    // Test Codable implementation
    func testCodableImplementation() {
        // Create a todo
        let todo = TodoItem(id: UUID(), title: "Test Task", isCompleted: false, priority: .high, dueDate: Date())
        
        // Encode to JSON
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(todo)
            
            // Decode from JSON
            let decoder = JSONDecoder()
            let decodedTodo = try decoder.decode(TodoItem.self, from: data)
            
            // Test decoded properties
            XCTAssertEqual(decodedTodo.id, todo.id)
            XCTAssertEqual(decodedTodo.title, todo.title)
            XCTAssertEqual(decodedTodo.isCompleted, todo.isCompleted)
            XCTAssertEqual(decodedTodo.priority, todo.priority)
            XCTAssertNotNil(decodedTodo.dueDate)
        } catch {
            XCTFail("Failed to encode/decode TodoItem: \(error)")
        }
    }
}

// Helper function to run tests
func runTodoListTests() {
    let testSuite = TodoListTests()
    
    // Run all tests
    let tests = [
        testSuite.testTodoItemModel,
        testSuite.testTodoStore,
        testSuite.testColorTheme,
        testSuite.testPriorityEnum,
        testSuite.testOverdueFunctionality,
        testSuite.testCodableImplementation
    ]
    
    var passedTests = 0
    var failedTests = 0
    
    for (index, test) in tests.enumerated() {
        do {
            try test()
            print("✅ Test \(index + 1) passed")
            passedTests += 1
        } catch {
            print("❌ Test \(index + 1) failed: \(error)")
            failedTests += 1
        }
    }
    
    print("Test Results: \(passedTests) passed, \(failedTests) failed")
}

// Uncomment to run tests
// runTodoListTests()
