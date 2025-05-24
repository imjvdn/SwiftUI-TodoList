<div align="center">

# 📝 SwiftUI Todo List

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.5+-orange.svg" alt="Swift 5.5+"/>
  <img src="https://img.shields.io/badge/SwiftUI-3.0+-blue.svg" alt="SwiftUI 3.0+"/>
  <img src="https://img.shields.io/badge/iOS-15.0+-lightgrey.svg" alt="iOS 15.0+"/>
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License: MIT"/>
</p>

<p align="center">A modern, declarative task management application showcasing SwiftUI's powerful architecture and Apple's Human Interface Guidelines.</p>

<p align="center"><strong>This repository contains TWO implementations:</strong></p>
<p align="center">1. A SwiftUI Playground prototype in the root directory</p>
<p align="center">2. A full Xcode project with CoreData in the <code>TodoList/</code> directory (now fully functional!)</p>

</div>

## 🌟 Overview

This Todo List application demonstrates Apple's recommended patterns and practices for building performant, maintainable iOS applications using SwiftUI. The project serves as both a practical utility and a technical showcase of modern iOS development principles.

### Project Structure

This repository contains two complete implementations of the same Todo List app:

1. **SwiftUI Playground Prototype** (in root directory)
   - Located in `MyPlayground.playground`
   - Uses UserDefaults for data persistence
   - Perfect for learning and experimentation
   - Includes a test runner in `TestRunner.playground`

2. **Full Xcode Project** (in `TodoList/` directory)
   - Complete iOS app with proper project structure
   - Uses CoreData for robust data persistence
   - Includes unit tests and UI tests
   - Ready for further development and App Store submission
   - **NEW**: Now works with the default CoreData model without requiring manual setup
   - **NEW**: Added "Clear All Tasks" feature for easy data management
   - **NEW**: Added deletion notifications for improved user feedback

## ✨ Key Features

- **Intuitive Task Management**
  - Add tasks with real-time validation
  - Mark completion with smooth state transitions
  - Swipe-to-delete with haptic feedback
  - Batch editing capabilities
  - **Clear All Tasks** feature for quick reset
  - **Data persistence** across app launches
  - **Priority levels** (High, Medium, Low) with visual indicators
  - **Due dates** with overdue status indicators
  - **Dark mode support** with theme switching
  - **Notification banners** for task completion, addition, and deletion feedback

- **Thoughtful UI Design**
  - SF Symbols integration for visual consistency
  - Adaptive layout supporting all iOS devices
  - Semantic colors for accessibility
  - Animation-enhanced interactions
  - Task completion status indicator
  - Color-coded priority indicators
  - Date picker for setting deadlines
  - Visual overdue status alerts
  - Light/dark/system theme options
  - Color-coded notification banners (green for completion, red for deletion, blue for addition)

## 🏛 Architecture

This application follows Apple's recommended architectural patterns:

### Playground Version

```swift
// MVVM Pattern with SwiftUI
enum ColorTheme: String, Codable { /* Theme Model */ }

enum Priority: String, Codable, CaseIterable { /* Enum Model */ }

struct TodoItem: Identifiable, Codable {
    /* Model with computed properties */
    var isOverdue: Bool { /* Logic to determine if task is past due date */ }
}

class TodoStore: ObservableObject {
    /* ViewModel with business logic */
    @Published var todoItems: [TodoItem] = []
    
    func addTodo(title: String, priority: Priority) { /* Logic */ }
    func toggleCompletion(for item: TodoItem) -> String { /* Logic */ }
    func deleteTodo(at offsets: IndexSet) { /* Logic */ }
}

struct TodoListView: View {
    /* View layer with UI components */
    @StateObject private var store = TodoStore()
    
    var body: some View {
        /* Declarative UI defined by state */
    }
}
```

### Xcode Project Version

```swift
// CoreData with MVVM
// Data Model: TodoList.xcdatamodeld
// Entity: Item with attributes (id, title, isCompleted, priority, dueDate, timestamp)

struct PersistenceController {
    /* CoreData stack management */
    static let shared = PersistenceController()
    let container: NSPersistentContainer
}

extension Item {
    /* Model extensions with computed properties */
    var priorityEnum: Priority { /* Convert from CoreData to enum */ }
    var isOverdue: Bool { /* Logic to determine if task is past due date */ }
}

struct TodoListView: View {
    /* View with CoreData integration */
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var items: FetchedResults<Item>
    
    var body: some View {
        /* Declarative UI defined by CoreData state */
    }
}
```

## 🧩 Technical Implementation

### Playground Version

| Component | Implementation |
|-----------|----------------|
| **State Management** | `@StateObject` and `@Published` for reactive state |
| **Data Flow** | One-way data flow with `Binding` |
| **Data Persistence** | UserDefaults with JSON encoding/decoding |
| **Date Handling** | `DatePicker` and `DateFormatter` for due dates |
| **UI Components** | Composition-based view hierarchy |
| **User Interaction** | Declarative gesture handling |
| **Animations** | Spring animations and transitions for notifications |
| **Feedback System** | Custom notification banners with auto-dismiss |
| **Rendering** | Optimized with identity-based diffing |

## 📱 SwiftUI Techniques Demonstrated

- **Declarative Syntax**
  ```swift
  var body: some View {
      NavigationView {
          VStack {
              // Content defined by its state
          }
      }
  }
  ```

- **Property Wrappers**
  - `@StateObject` for view model lifecycle management
  - `@Published` for observable state
  - `$` prefix for two-way bindings

- **Composition Over Inheritance**
  ```swift
  struct TodoItemRow: View {
      let item: TodoItem
      var body: some View {
          HStack {
              // Reusable component
          }
      }
  }
  ```

- **Reactive Updates**
  ```swift
  @Published var todoItems: [TodoItem] = [] {
      didSet {
          saveItems() // React to state changes
      }
  }
  ```

## 🔧 Recent Updates

### May 23, 2025

- **Delete Notifications**: Added visual feedback when tasks are deleted (single or batch deletion)
- **Clear All Tasks Feature**: Added a button in the toolbar to easily clear all tasks with notification feedback
- **Improved Sample Data**: Updated the preview data generation to work properly with the CoreData model
- **Branch-Based Workflow**: Implemented a proper Git branching strategy for feature development and bug fixes
- **CoreData Implementation Simplified**: The app now works with the default CoreData model without requiring manual attribute setup
- **Adaptive UI**: Added computed properties to simulate the full model functionality while using the basic CoreData structure
- **Fixed Build Issues**: Resolved compilation errors related to Identifiable protocol conformance
- **Added .gitignore**: Added a comprehensive .gitignore file for Swift and Xcode projects

## 🛠️ Installation

### Option 1: SwiftUI Playground

1. Clone this repository
2. Open `MyPlayground.playground` in Xcode
3. Run the playground to see the Todo List in action

### Option 2: Full Xcode Project

1. Clone this repository
2. Open the `TodoList/TodoList.xcodeproj` file in Xcode
3. Build and run the project on your simulator or device

## 🧪 Testing

### Playground Version

1. Open `TestRunner.playground` in Xcode
2. Run the playground to execute the test suite
3. View test results in the console

### Xcode Project Version

1. Open the `TodoList.xcodeproj` file in Xcode
2. Select Product > Test (⌘U) to run the test suite
3. View test results in the Test Navigator

## 🗺 Roadmap

- [ ] Categories/Tags for tasks
- [ ] Search and filtering
- [ ] Recurring tasks
- [ ] Calendar integration
- [ ] Widgets for home screen
- [ ] iCloud sync
- [ ] Shortcuts app integration
- [ ] Localization

## 📄 License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 👨‍💻 Author

Created by Jadan Morrow

---


