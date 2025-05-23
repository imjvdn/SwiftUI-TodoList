//
//  TodoListUITests.swift
//  TodoListUITests
//
//  Created by Jadan Morrow on 5/23/25.
//

import XCTest

final class TodoListUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Initialize the app
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    @MainActor
    func testAddingTodoItem() throws {
        // Test adding a new todo item
        
        // Get the initial count of items
        let initialItemCount = app.cells.count
        
        // Enter text in the text field
        let textField = app.textFields["Add a new task"]
        XCTAssertTrue(textField.exists, "Text field should exist")
        textField.tap()
        textField.typeText("UI Test Task")
        
        // Tap the add button
        let addButton = app.buttons["plus.circle.fill"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        addButton.tap()
        
        // Verify a new item was added
        let newItemCount = app.cells.count
        XCTAssertEqual(newItemCount, initialItemCount + 1, "A new item should have been added")
        
        // Verify the item has the correct text
        XCTAssertTrue(app.staticTexts["UI Test Task"].exists, "The new task should be visible")
    }
    
    @MainActor
    func testCompletingTodoItem() throws {
        // First add a new item
        let textField = app.textFields["Add a new task"]
        textField.tap()
        textField.typeText("Complete This Task")
        app.buttons["plus.circle.fill"].tap()
        
        // Find the item and mark it as complete
        let taskText = app.staticTexts["Complete This Task"]
        XCTAssertTrue(taskText.exists, "The task should exist")
        
        // Find the circle button next to the task and tap it
        let taskCell = taskText.ancestors(matching: .cell).firstMatch
        let completeButton = taskCell.buttons["circle"]
        if completeButton.exists {
            completeButton.tap()
            
            // Verify the notification appears
            let notification = app.staticTexts["Completed: Complete This Task"]
            XCTAssertTrue(notification.waitForExistence(timeout: 2), "Completion notification should appear")
        } else {
            XCTFail("Complete button not found")
        }
    }
    
    @MainActor
    func testThemeToggle() throws {
        // Test changing the theme
        
        // Open the theme menu
        let themeButton = app.buttons["circle.lefthalf.filled"]
        XCTAssertTrue(themeButton.exists, "Theme button should exist")
        themeButton.tap()
        
        // Select dark mode
        let darkModeButton = app.buttons["Dark Mode"]
        if darkModeButton.waitForExistence(timeout: 2) {
            darkModeButton.tap()
            // Note: It's difficult to test the actual color scheme change in UI tests
            // We're just testing that the button exists and can be tapped
        } else {
            XCTFail("Dark mode button not found")
        }
    }
    
    @MainActor
    func testDeleteTodoItem() throws {
        // First add a new item
        let textField = app.textFields["Add a new task"]
        textField.tap()
        textField.typeText("Delete This Task")
        app.buttons["plus.circle.fill"].tap()
        
        // Get the initial count of items
        let initialItemCount = app.cells.count
        
        // Find the item and swipe to delete
        let taskText = app.staticTexts["Delete This Task"]
        XCTAssertTrue(taskText.exists, "The task should exist")
        
        let taskCell = taskText.ancestors(matching: .cell).firstMatch
        taskCell.swipeLeft()
        
        // Tap the delete button
        app.buttons["Delete"].tap()
        
        // Verify the item was deleted
        let newItemCount = app.cells.count
        XCTAssertEqual(newItemCount, initialItemCount - 1, "The item should have been deleted")
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
