//
//  Formatters.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import Foundation

// Date formatter for displaying dates in the app
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
