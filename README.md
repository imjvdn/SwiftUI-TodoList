<div align="center">

# 📝 SwiftUI Todo List

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.5+-orange.svg" alt="Swift 5.5+"/>
  <img src="https://img.shields.io/badge/SwiftUI-3.0+-blue.svg" alt="SwiftUI 3.0+"/>
  <img src="https://img.shields.io/badge/iOS-15.0+-lightgrey.svg" alt="iOS 15.0+"/>
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License: MIT"/>
</p>

<p align="center">A modern, declarative task management application showcasing SwiftUI's powerful architecture and Apple's Human Interface Guidelines.</p>

</div>

## 🌟 Overview

This Todo List application demonstrates Apple's recommended patterns and practices for building performant, maintainable iOS applications using SwiftUI. The project serves as both a practical utility and a technical showcase of modern iOS development principles.

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

To run the tests:

1. Open the `TestRunner.playground` file in Xcode
2. Run the playground to execute all tests
3. View the results in the live view or console output

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/imjvdn/SwiftUI-TodoList.git

# Navigate to the project directory
cd SwiftUI-TodoList

# Open in Xcode
open MyPlayground.playground
```

## 🔮 Future Roadmap

| Feature | Description | Priority |
|---------|-------------|----------|
| **Categories/Tags** | Group tasks by custom categories | High |
| **Calendar Integration** | Export tasks to system calendar | Medium |
| **Advanced Persistence** | CoreData integration with `@FetchRequest` | Medium |
| **Enhanced Animations** | Additional micro-interactions and transitions | Low |
| **Widgets** | Home screen quick-access widgets | Low |
| **Shortcuts** | Siri and Shortcuts integration | Low |
| **CloudKit** | Cross-device synchronization | Low |
| **UI Tests** | Add XCTest UI tests for interface testing | Low |

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
