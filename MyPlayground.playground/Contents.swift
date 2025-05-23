//: A SwiftUI based To-Do List App with Data Persistence and Priority Levels
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
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var priority: Priority = .medium
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
    func addTodo(title: String, priority: Priority = .medium) {
        let newTodo = TodoItem(title: title, priority: priority)
        todoItems.append(newTodo)
    }
    
    // Update priority for a todo item
    func updatePriority(for todo: TodoItem, to priority: Priority) {
        if let index = todoItems.firstIndex(where: { $0.id == todo.id }) {
            todoItems[index].priority = priority
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
                            
                            // Task title
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundColor(item.isCompleted ? .gray : .primary)
                            
                            Spacer()
                            
                            // Priority menu
                            Menu {
                                ForEach(Priority.allCases, id: \.self) { priority in
                                    Button(action: {
                                        todoStore.updatePriority(for: item, to: priority)
                                    }) {
                                        Label(priority.rawValue, systemImage: priority.icon)
                                    }
                                }
                            } label: {
                                Text(item.priority.rawValue)
                                    .font(.caption)
                                    .foregroundColor(item.priority.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(item.priority.color, lineWidth: 1)
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
        todoStore.addTodo(title: newItemTitle, priority: selectedPriority)
        newItemTitle = ""
        selectedPriority = .medium // Reset to default priority
    }
}

// Set up the live view with our SwiftUI view
PlaygroundPage.current.setLiveView(TodoListView().frame(width: 375, height: 600))
