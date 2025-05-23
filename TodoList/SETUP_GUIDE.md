# SwiftUI Todo List - Setup Guide

This guide will help you complete the setup of your Todo List app after migrating from the playground to a full Xcode project.

## CoreData Model Setup

The most important step is to configure the CoreData model with all the required attributes:

1. Open the `TodoList.xcodeproj` file in Xcode
2. In the Project Navigator, find and open the `TodoList.xcdatamodeld` file
3. Select the "Item" entity and add these attributes:
   - `id`: UUID (Check "Optional")
   - `title`: String
   - `isCompleted`: Boolean (Check "Use scalar type")
   - `priority`: Integer 16 (Check "Use scalar type")
   - `dueDate`: Date (Check "Optional")
   - Keep the existing `timestamp` attribute
4. Save the changes (Command+S)
5. Build the project (Command+B)

## Uncomment the Full Implementation

After setting up the CoreData model, you'll need to uncomment the full implementation code:

1. Open `TodoList/Models/TodoItemExtension.swift`
2. Uncomment the code inside the large comment block (lines ~25-125)
3. Open `TodoList/Views/TodoListView.swift`
4. Replace the simplified implementation with the full implementation from your playground

## Running the App

1. Select a simulator or device
2. Press Command+R to run the app
3. Test all features to ensure they work correctly

## Running Tests

The project includes both unit tests and UI tests:

1. Use Command+U to run all tests
2. Navigate to the Test Navigator (Command+6) to run individual tests

## Next Steps

Now that you have a full Xcode project, you can:

1. Add more features from your roadmap
2. Enhance the UI with more animations
3. Add widgets for the home screen
4. Implement CloudKit for cross-device synchronization
5. Submit to the App Store

## Troubleshooting

If you encounter any issues:

1. Make sure all CoreData attributes are properly configured
2. Check that you've uncommented all the necessary code
3. Ensure all files are included in the project target
4. Clean the build folder (Shift+Command+K) and rebuild

Happy coding!
