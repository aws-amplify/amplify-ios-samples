//
//  ToDoItemExtension.swift
//  ToDo
//
//  Created by Zhu, Yiming on 6/25/21.
//

import Foundation

extension ToDoItem: Identifiable, Equatable{
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    public init(id: String? = nil, priority: ToDoPriority = .medium, text: String = "") {
        if let id = id {
            self.init(id: id, priority: priority, text: text, completedAt: nil)
        }
        else{
            self.init(priority: priority, text: text, completedAt: nil)
        }
    }
}

public typealias ToDoItems = [ToDoItem]

