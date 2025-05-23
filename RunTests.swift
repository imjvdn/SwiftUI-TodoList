import Foundation

// Priority enum for tasks
enum Priority: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: String {
        switch self {
        case .high: return "red"
        case .medium: return "orange"
        case .low: return "blue"
        }
    }
    
    var icon: String {
        switch self {
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
}

// Theme enum for light/dark mode
enum ColorTheme: String, Codable {
    case light, dark, system
    
    func effectiveColorScheme(systemScheme: String?) -> String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        case .system: return systemScheme ?? "light"
        }
    }
}

// Model for a To-Do item with Codable for persistence
struct TodoItem: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, priority: Priority = .medium, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
    }
    
    // Computed property to check if task is overdue
    var isOverdue: Bool {
        if let dueDate = dueDate, !isCompleted {
            return dueDate < Date()
        }
        return false
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.isCompleted == rhs.isCompleted &&
               lhs.priority == rhs.priority
    }
}

// TodoStore to handle data persistence and app settings
class TodoStore {
    // Property that stores todo items
    var todoItems: [TodoItem] = []
    
    // Theme setting with default to system
    var colorTheme: ColorTheme = .system
    
    // Add a new todo item
    func addTodo(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        let newTodo = TodoItem(title: title, priority: priority, dueDate: dueDate)
        todoItems.append(newTodo)
    }
    
    // Toggle completion status and return the updated item title for notification
    func toggleCompletion(for todo: TodoItem) -> String {
        if let index = todoItems.firstIndex(where: { $0.id == todo.id }) {
            todoItems[index].isCompleted.toggle()
            return todoItems[index].title
        }
        return ""
    }
    
    // Update priority for a todo item
    func updatePriority(for todo: TodoItem, to priority: Priority) {
        if let index = todoItems.firstIndex(where: { $0.id == todo.id }) {
            todoItems[index].priority = priority
        }
    }
    
    // Update due date for a todo item
    func updateDueDate(for todo: TodoItem, to dueDate: Date?) {
        if let index = todoItems.firstIndex(where: { $0.id == todo.id }) {
            todoItems[index].dueDate = dueDate
        }
    }
    
    // Delete todos at specified offsets
    func deleteTodos(at offsets: IndexSet) {
        var indexesToRemove: [Int] = []
        for index in offsets {
            indexesToRemove.append(index)
        }
        
        // Sort in descending order to avoid index shifting issues
        indexesToRemove.sort(by: >)
        
        for index in indexesToRemove {
            if index < todoItems.count {
                todoItems.remove(at: index)
            }
        }
    }
}

// Test suite for the Todo List app
class TodoListTests {
    
    // Test TodoItem model
    func testTodoItemModel() {
        print("Running testTodoItemModel...")
        
        // Create a todo item
        let dueDate = Date().addingTimeInterval(24 * 60 * 60) // Tomorrow
        let todo = TodoItem(id: UUID(), title: "Test Task", isCompleted: false, priority: .high, dueDate: dueDate)
        
        // Test properties
        assert(todo.title == "Test Task", "Title should be 'Test Task'")
        assert(todo.isCompleted == false, "isCompleted should be false")
        assert(todo.priority == Priority.high, "Priority should be high")
        assert(todo.dueDate != nil, "Due date should not be nil")
        assert(todo.isOverdue == false, "Task should not be overdue since due date is tomorrow")
        
        print("✅ testTodoItemModel passed")
    }
    
    // Test TodoStore functionality
    func testTodoStore() {
        print("Running testTodoStore...")
        
        let store = TodoStore()
        
        // Test adding a todo
        store.addTodo(title: "Test Task", priority: .medium)
        assert(store.todoItems.count == 1, "Store should have 1 item")
        assert(store.todoItems[0].title == "Test Task", "Title should be 'Test Task'")
        assert(store.todoItems[0].priority == .medium, "Priority should be medium")
        
        // Test toggling completion
        let title = store.toggleCompletion(for: store.todoItems[0])
        assert(title == "Test Task", "Returned title should be 'Test Task'")
        assert(store.todoItems[0].isCompleted == true, "Task should be completed")
        
        // Test updating priority
        store.updatePriority(for: store.todoItems[0], to: .high)
        assert(store.todoItems[0].priority == .high, "Priority should be high")
        
        // Test updating due date
        let tomorrow = Date().addingTimeInterval(24 * 60 * 60)
        store.updateDueDate(for: store.todoItems[0], to: tomorrow)
        assert(store.todoItems[0].dueDate != nil, "Due date should not be nil")
        
        // Test deleting todos
        store.deleteTodos(at: IndexSet(integer: 0))
        assert(store.todoItems.count == 0, "Store should be empty")
        
        print("✅ testTodoStore passed")
    }
    
    // Test ColorTheme functionality
    func testColorTheme() {
        print("Running testColorTheme...")
        
        // Test light theme
        let lightTheme = ColorTheme.light
        assert(lightTheme.effectiveColorScheme(systemScheme: "dark") == "light", "Light theme should return light scheme regardless of system")
        
        // Test dark theme
        let darkTheme = ColorTheme.dark
        assert(darkTheme.effectiveColorScheme(systemScheme: "light") == "dark", "Dark theme should return dark scheme regardless of system")
        
        // Test system theme
        let systemTheme = ColorTheme.system
        assert(systemTheme.effectiveColorScheme(systemScheme: "light") == "light", "System theme should follow system (light)")
        assert(systemTheme.effectiveColorScheme(systemScheme: "dark") == "dark", "System theme should follow system (dark)")
        assert(systemTheme.effectiveColorScheme(systemScheme: nil) == "light", "System theme should default to light if nil")
        
        print("✅ testColorTheme passed")
    }
    
    // Test Priority enum
    func testPriorityEnum() {
        print("Running testPriorityEnum...")
        
        // Test high priority
        let highPriority = Priority.high
        assert(highPriority.rawValue == "High", "High priority rawValue should be 'High'")
        assert(highPriority.icon == "exclamationmark.triangle.fill", "High priority icon should be 'exclamationmark.triangle.fill'")
        
        // Test medium priority
        let mediumPriority = Priority.medium
        assert(mediumPriority.rawValue == "Medium", "Medium priority rawValue should be 'Medium'")
        assert(mediumPriority.icon == "exclamationmark.circle.fill", "Medium priority icon should be 'exclamationmark.circle.fill'")
        
        // Test low priority
        let lowPriority = Priority.low
        assert(lowPriority.rawValue == "Low", "Low priority rawValue should be 'Low'")
        assert(lowPriority.icon == "info.circle.fill", "Low priority icon should be 'info.circle.fill'")
        
        print("✅ testPriorityEnum passed")
    }
    
    // Test overdue functionality
    func testOverdueFunctionality() {
        print("Running testOverdueFunctionality...")
        
        // Create a todo with past due date
        let pastDate = Date().addingTimeInterval(-24 * 60 * 60) // Yesterday
        let overdueTodo = TodoItem(id: UUID(), title: "Overdue Task", isCompleted: false, priority: .high, dueDate: pastDate)
        
        // Test overdue status
        assert(overdueTodo.isOverdue == true, "Task with past due date should be overdue")
        
        // Test completed tasks are not overdue even with past due date
        let completedOverdueTodo = TodoItem(id: UUID(), title: "Completed Overdue Task", isCompleted: true, priority: .high, dueDate: pastDate)
        assert(completedOverdueTodo.isOverdue == false, "Completed task should not be overdue even with past due date")
        
        // Test tasks without due date are not overdue
        let noDueDateTodo = TodoItem(id: UUID(), title: "No Due Date Task", isCompleted: false, priority: .medium)
        assert(noDueDateTodo.isOverdue == false, "Task without due date should not be overdue")
        
        print("✅ testOverdueFunctionality passed")
    }
    
    // Test Codable implementation
    func testCodableImplementation() {
        print("Running testCodableImplementation...")
        
        // Create a todo
        let id = UUID()
        let todo = TodoItem(id: id, title: "Test Task", isCompleted: false, priority: .high, dueDate: Date())
        
        // Encode to JSON
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(todo)
            
            // Decode from JSON
            let decoder = JSONDecoder()
            let decodedTodo = try decoder.decode(TodoItem.self, from: data)
            
            // Test decoded properties
            assert(decodedTodo.id == todo.id, "Decoded ID should match original")
            assert(decodedTodo.title == todo.title, "Decoded title should match original")
            assert(decodedTodo.isCompleted == todo.isCompleted, "Decoded completion status should match original")
            assert(decodedTodo.priority == todo.priority, "Decoded priority should match original")
            assert(decodedTodo.dueDate != nil, "Decoded due date should not be nil")
            
            print("✅ testCodableImplementation passed")
        } catch {
            print("❌ testCodableImplementation failed: \(error)")
        }
    }
    
    // Run all tests
    func runAllTests() {
        print("🧪 Running Todo List Tests...")
        
        testTodoItemModel()
        testTodoStore()
        testColorTheme()
        testPriorityEnum()
        testOverdueFunctionality()
        testCodableImplementation()
        
        print("✅ All tests passed!")
    }
}

// Run the tests
let tests = TodoListTests()
tests.runAllTests()
