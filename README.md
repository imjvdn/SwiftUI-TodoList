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
<p align="center">2. A full Xcode project with CoreData in the <code>TodoList/</code> directory</p>

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

## ✨ Key Features

- **Intuitive Task Management**
  - Add tasks with real-time validation
  - Mark completion with smooth state transitions
  - Swipe-to-delete with haptic feedback
  - Batch editing capabilities
  - **Data persistence** across app launches
  - **Priority levels** (High, Medium, Low) with visual indicators
  - **Due dates** with overdue status indicators
  - **Dark mode support** with theme switching
  - **Notification banners** for task completion feedback

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
  - Animated notification banners with auto-dismiss

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
    /* ViewModel with theme management */
    @Published var colorTheme: ColorTheme
    
    func toggleCompletion(for todo: TodoItem) -> String { /* Returns title for notification */ }
}

struct NotificationBanner: View { /* Reusable notification component */ }

struct TodoListView: View { 
    /* View with environment awareness */
    @Environment(\.colorScheme) private var colorScheme
    @State private var showNotification = false
}

// State Management
@StateObject private var todoStore = TodoStore()
```

### Xcode Project Version

The full Xcode project enhances the architecture with CoreData integration:

```swift
// MVVM Pattern with CoreData
enum ColorTheme: String, Codable { 
    /* Theme Model with CoreData compatibility */
    func fromRawIndex(_ index: Int16) -> ColorTheme
}

enum Priority: String, Codable, CaseIterable { 
    /* Enum Model with CoreData compatibility */
    var rawIndex: Int16 { /* For CoreData storage */ }
}

// CoreData Entity
extension Item { // NSManagedObject
    /* CoreData entity with computed properties */
    var isOverdue: Bool { /* Logic to determine if task is past due date */ }
    var priorityEnum: Priority { /* Convert from CoreData storage */ }
    
    static func createItem(title: String, priority: Priority, dueDate: Date?, in context: NSManagedObjectContext) -> Item
}

class SettingsManager: ObservableObject { 
    /* App settings with persistence */
    @Published var colorTheme: ColorTheme
}

struct TodoListView: View { 
    /* View with CoreData and environment integration */
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var items: FetchedResults<Item>
}
```

### Technical Implementation

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
  - Small, focused view components
  - Reusable, testable building blocks

- **Reactive Updates**
  - UI automatically reflects state changes
  - No manual view refreshing required

## 🪢 Testing

This project includes comprehensive tests to ensure code quality and reliability:

- **Model Tests**: Verify the `TodoItem` model properties and behavior
- **Store Tests**: Validate the `TodoStore` CRUD operations
- **Theme Tests**: Confirm proper theme switching functionality
- **Priority Tests**: Ensure priority enum values and properties work correctly
- **Overdue Tests**: Verify overdue status calculation logic
- **Persistence Tests**: Test Codable implementation for data storage

### Playground Tests

To run the playground tests:

1. Open the `TestRunner.playground` file in Xcode
2. Run the playground to execute all tests
3. View the results in the live view or console output

### Standalone Tests

A standalone test file is also available that can be run from the command line:

```bash
# Run the standalone tests
swift RunTests.swift
```

### Xcode Project Tests

The Xcode project includes both unit tests and UI tests:

1. Open the `TodoList.xcodeproj` file in Xcode
2. Use ⌘+U to run all tests
3. Navigate to the Test Navigator (⌘+6) to run individual tests

## 🚀 Getting Started

### Playground Version

```bash
# Clone the repository
git clone https://github.com/imjvdn/SwiftUI-TodoList.git

# Navigate to the project directory
cd SwiftUI-TodoList

# Open in Xcode
open MyPlayground.playground
```

### Full Xcode Project

The project has been migrated to a full Xcode project with CoreData integration:

```bash
# Navigate to the Xcode project directory
cd SwiftUI-TodoList/TodoList

# Open in Xcode
open TodoList.xcodeproj
```

#### CoreData Setup

Before running the Xcode project, you need to set up the CoreData model:

1. Open the `TodoList.xcdatamodeld` file in Xcode
2. Select the "Item" entity and add these attributes:
   - `id`: UUID (Optional)
   - `title`: String
   - `isCompleted`: Boolean (Use scalar type)
   - `priority`: Integer 16 (Use scalar type)
   - `dueDate`: Date (Optional)
   - Keep the existing `timestamp` attribute
3. Save and build the project

## 🔮 Future Roadmap

| Feature | Description | Priority | Status |
|---------|-------------|----------|--------|
| **Categories/Tags** | Group tasks by custom categories | High | Planned |
| **Calendar Integration** | Export tasks to system calendar | Medium | Planned |
| **Advanced Persistence** | CoreData integration with `@FetchRequest` | Medium | ✅ Completed |
| **Enhanced Animations** | Additional micro-interactions and transitions | Low | Planned |
| **Widgets** | Home screen quick-access widgets | Low | Planned |
| **Shortcuts** | Siri and Shortcuts integration | Low | Planned |
| **CloudKit** | Cross-device synchronization | Low | Planned |
| **UI Tests** | Add XCTest UI tests for interface testing | Low | ✅ Completed |

## 🛠 Technical Requirements

- **Xcode** 13.0+
- **Swift** 5.5+
- **iOS/iPadOS** 15.0+
- **macOS** 12.0+ (for Mac Catalyst)

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

## 📄 License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

<div align="center">
<p>© 2025 Jadan Morrow</p>
</div>
