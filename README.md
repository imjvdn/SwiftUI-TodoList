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

<div align="center">
<i>"Simple, but not simpler" — Inspired by Apple Design Philosophy</i>
</div>

## ✨ Key Features

- **Intuitive Task Management**
  - Add tasks with real-time validation
  - Mark completion with smooth state transitions
  - Swipe-to-delete with haptic feedback
  - Batch editing capabilities

- **Thoughtful UI Design**
  - SF Symbols integration for visual consistency
  - Adaptive layout supporting all iOS devices
  - Semantic colors for accessibility
  - Animation-enhanced interactions

## 🏛 Architecture

This application follows Apple's recommended architectural patterns:

```swift
// MVVM Pattern with SwiftUI
struct TodoItem: Identifiable { /* Model */ }

struct TodoListView: View { /* View */ }

// State Management
@State private var todoItems: [TodoItem] = []
```

### Technical Implementation

| Component | Implementation |
|-----------|----------------|
| **State Management** | `@State` for view-local state |
| **Data Flow** | One-way data flow with `Binding` |
| **UI Components** | Composition-based view hierarchy |
| **User Interaction** | Declarative gesture handling |
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
  - `@State` for single source of truth
  - `$` prefix for two-way bindings

- **Composition Over Inheritance**
  - Small, focused view components
  - Reusable, testable building blocks

- **Reactive Updates**
  - UI automatically reflects state changes
  - No manual view refreshing required

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
| **Persistence** | CoreData integration with `@FetchRequest` | High |
| **Animations** | Custom transitions and micro-interactions | Medium |
| **Widgets** | Home screen quick-access widgets | Medium |
| **Shortcuts** | Siri and Shortcuts integration | Low |
| **CloudKit** | Cross-device synchronization | Low |

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
