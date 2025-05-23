//
//  CoreDataSetupGuide.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import Foundation

/*
 CORE DATA MODEL SETUP GUIDE
 
 To complete the CoreData model setup, you'll need to open the Xcode project and modify the data model visually.
 Follow these steps:
 
 1. Open the TodoList.xcodeproj file in Xcode
 
 2. In the Project Navigator, find and open the TodoList.xcdatamodeld file
 
 3. Select the "Item" entity and add the following attributes:
    - id: UUID (Check "Optional")
    - title: String
    - isCompleted: Boolean (Check "Use scalar type")
    - priority: Integer 16 (Check "Use scalar type")
    - dueDate: Date (Check "Optional")
    
    Note: Keep the existing "timestamp" attribute
 
 4. Save the changes (Command+S)
 
 5. Build the project (Command+B) to generate the updated model code
 
 Once these steps are completed, the CoreData model will be ready to work with the rest of the code.
 */
