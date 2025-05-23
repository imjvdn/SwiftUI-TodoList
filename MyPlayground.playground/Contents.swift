//: A SwiftUI based To-Do List App with Data Persistence, Priority Levels, and Due Dates
import SwiftUI
import PlaygroundSupport

// Priority enum for tasks
enum Priority: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
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

// Model for a To-Do item with Codable for persistence
struct TodoItem: Identifiable, Codable {
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
}

// TodoStore to handle data persistence
class TodoStore: ObservableObject {
    // Published property that triggers UI updates when changed
    @Published var todoItems: [TodoItem] = [] {
        didSet {
            saveTodos()
        }
    }
    
    // Key for UserDefaults storage
    private let todosKey = "TodoItems"
    
    init() {
        loadTodos()
    }
    
    // Load todos from UserDefaults
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: todosKey) {
            if let decodedTodos = try? JSONDecoder().decode([TodoItem].self, from: data) {
                todoItems = decodedTodos
                return
            }
        }
        
        // If no saved data or decoding fails, start with empty list
        todoItems = []
    }
    
    // Save todos to UserDefaults
    private func saveTodos() {
        if let encodedData = try? JSONEncoder().encode(todoItems) {
            UserDefaults.standard.set(encodedData, forKey: todosKey)
        }
    }
    
    // Add a new todo item
    func addTodo(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        let newTodo = TodoItem(title: title, priority: priority, dueDate: dueDate)
        todoItems.append(newTodo)
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
    
    // Toggle completion status
    func toggleCompletion(for todo: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todo.id }) {
            todoItems[index].isCompleted.toggle()
        }
    }
    
    // Delete todos at specified offsets
    func deleteTodos(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
}

// Main view for the To-Do List app
struct TodoListView: View {
    // StateObject for the TodoStore to persist across view updates
    @StateObject private var todoStore = TodoStore()
    
    // State for the new item text field
    @State private var newItemTitle: String = ""
    
    // State for the selected priority
    @State private var selectedPriority: Priority = .medium
    
    // State for the due date picker
    @State private var selectedDueDate: Date = Date().addingTimeInterval(24 * 60 * 60) // Default to tomorrow
    @State private var isDueDateEnabled: Bool = false
    
    // Date formatter for displaying dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                // Input area for adding new items
                VStack(spacing: 10) {
                    HStack {
                        TextField("Add a new task", text: $newItemTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                        }
                        .disabled(newItemTitle.isEmpty)
                    }
                    
                    // Priority selection
                    HStack {
                        Text("Priority:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Picker("Priority", selection: $selectedPriority) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                Label(priority.rawValue, systemImage: priority.icon)
                                    .foregroundColor(priority.color)
                                    .tag(priority)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Due date selection
                    VStack(alignment: .leading, spacing: 5) {
                        Toggle("Set due date", isOn: $isDueDateEnabled)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if isDueDateEnabled {
                            DatePicker(
                                "Due date",
                                selection: $selectedDueDate,
                                in: Date()...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                        }
                    }
                }
                .padding()
                
                // List of to-do items
                List {
                    ForEach(todoStore.todoItems) { item in
                        HStack {
                            // Completion status
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    todoStore.toggleCompletion(for: item)
                                }
                            
                            // Priority indicator
                            Image(systemName: item.priority.icon)
                                .foregroundColor(item.priority.color)
                                .imageScale(.small)
                            
                            // Task title and due date
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .strikethrough(item.isCompleted)
                                    .foregroundColor(item.isCompleted ? .gray : (item.isOverdue ? .red : .primary))
                                
                                if let dueDate = item.dueDate {
                                    Text(dateFormatter.string(from: dueDate))
                                        .font(.caption2)
                                        .foregroundColor(item.isOverdue ? .red : .gray)
                                }
                            }
                            
                            Spacer()
                            
                            // Action menu (Priority and Due Date)
                            Menu {
                                // Priority submenu
                                Menu {
                                    ForEach(Priority.allCases, id: \.self) { priority in
                                        Button(action: {
                                            todoStore.updatePriority(for: item, to: priority)
                                        }) {
                                            Label(priority.rawValue, systemImage: priority.icon)
                                        }
                                    }
                                } label: {
                                    Label("Set Priority", systemImage: "flag.fill")
                                }
                                
                                // Due date actions
                                if item.dueDate == nil {
                                    Button(action: {
                                        let tomorrow = Date().addingTimeInterval(24 * 60 * 60)
                                        todoStore.updateDueDate(for: item, to: tomorrow)
                                    }) {
                                        Label("Add Due Date", systemImage: "calendar.badge.plus")
                                    }
                                } else {
                                    Button(action: {
                                        todoStore.updateDueDate(for: item, to: nil)
                                    }) {
                                        Label("Remove Due Date", systemImage: "calendar.badge.minus")
                                    }
                                    
                                    Button(action: {
                                        let tomorrow = Date().addingTimeInterval(24 * 60 * 60)
                                        todoStore.updateDueDate(for: item, to: tomorrow)
                                    }) {
                                        Label("Due Tomorrow", systemImage: "calendar")
                                    }
                                    
                                    Button(action: {
                                        let nextWeek = Date().addingTimeInterval(7 * 24 * 60 * 60)
                                        todoStore.updateDueDate(for: item, to: nextWeek)
                                    }) {
                                        Label("Due Next Week", systemImage: "calendar")
                                    }
                                }
                            } label: {
                                HStack(spacing: 2) {
                                    Text(item.priority.rawValue)
                                        .font(.caption)
                                        .foregroundColor(item.priority.color)
                                    
                                    if item.dueDate != nil {
                                        Image(systemName: "calendar")
                                            .font(.caption)
                                            .foregroundColor(item.isOverdue ? .red : .gray)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(item.isOverdue ? .red : item.priority.color, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .onDelete(perform: todoStore.deleteTodos)
                }
                
                // Status text showing number of items
                if !todoStore.todoItems.isEmpty {
                    HStack {
                        let completed = todoStore.todoItems.filter { $0.isCompleted }.count
                        let total = todoStore.todoItems.count
                        
                        Text("\(completed) of \(total) tasks completed")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                EditButton()
            }
        }
    }
    
    // Function to add a new item
    private func addItem() {
        guard !newItemTitle.isEmpty else { return }
        
        // Add the todo with or without due date based on toggle
        todoStore.addTodo(
            title: newItemTitle,
            priority: selectedPriority,
            dueDate: isDueDateEnabled ? selectedDueDate : nil
        )
        
        // Reset input fields
        newItemTitle = ""
        selectedPriority = .medium
        isDueDateEnabled = false
        selectedDueDate = Date().addingTimeInterval(24 * 60 * 60) // Reset to tomorrow
    }
}

// Set up the live view with our SwiftUI view
PlaygroundPage.current.setLiveView(TodoListView().frame(width: 375, height: 600))
