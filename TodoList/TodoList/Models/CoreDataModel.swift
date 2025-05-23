//
//  CoreDataModel.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import Foundation
import CoreData

// This file contains extensions and helper methods for working with the CoreData model

// MARK: - Item Entity Extensions
extension Item {
    // These are the attribute names for the Item entity
    struct Attributes {
        static let id = "id"
        static let title = "title"
        static let isCompleted = "isCompleted"
        static let priority = "priority"
        static let dueDate = "dueDate"
        static let timestamp = "timestamp"
    }
    
    // Helper method to set up the CoreData model programmatically
    static func setupCoreDataModel(with context: NSManagedObjectContext) {
        // This method would be called when the app first launches
        // to ensure the CoreData model has all required attributes
        
        // Note: In a production app, you would use CoreData migrations
        // This is a simplified approach for this project
    }
}

// MARK: - CoreData Model Setup
class CoreDataModelSetup {
    static func ensureModelAttributes() {
        // This would check if all required attributes exist in the model
        // and add them if needed
        
        // Note: In a real app, you would use proper CoreData migrations
        // This is just a placeholder for this project
    }
}
