//: A SwiftUI based To-Do List App with Data Persistence
import SwiftUI
import PlaygroundSupport

// Model for a To-Do item with Codable for persistence
struct TodoItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
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
    func addTodo(title: String) {
        let newTodo = TodoItem(title: title)
        todoItems.append(newTodo)
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
    
    var body: some View {
        NavigationView {
            VStack {
                // Input area for adding new items
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
                .padding()
                
                // List of to-do items
                List {
                    ForEach(todoStore.todoItems) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    todoStore.toggleCompletion(for: item)
                                }
                            
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundColor(item.isCompleted ? .gray : .primary)
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
        todoStore.addTodo(title: newItemTitle)
        newItemTitle = ""
    }
}

// Set up the live view with our SwiftUI view
PlaygroundPage.current.setLiveView(TodoListView().frame(width: 375, height: 600))
