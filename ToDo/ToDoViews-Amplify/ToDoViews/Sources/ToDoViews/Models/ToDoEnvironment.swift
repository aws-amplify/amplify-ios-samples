//
//  File.swift
//  
//
//  Created by Stehling, Brennan on 6/14/21.
//
import Amplify
import Foundation

class ObservableArray<T>: ObservableObject {
    @Published var array: [T]
    init(array: [T] = []) {
        self.array = array
    }
    init(repeating value: T, count: Int) {
        array = Array(repeating: value, count: count)
    }
}

/// Maintain all Todo information used in each view.
public class ToDoEnvironment: ObservableObject {
    ///Control ToDoItemDetail show or not. Used in ToDoList and ToDoItemDetail.
    @Published var showingDetail: Bool = false
    ///Store ToDoItems
    @Published var toDoItems: ToDoItems = []
    ///Store current Todo item information. Display in ToDoItemDetail.
    @Published var selectedToDoItem: ToDoItem? = nil
    ///how long will completed items disappear
    @Published var displayTime: Double = 3.0
    public init() {}
    
    /// Check id to know whether the item is in the todoItems, then determine update or add.
    /// - Parameter toDoItem: New one from ToDoItemDetail through Save button.
    public func save(toDoItem: ToDoItem) {
        let index = toDoItems.firstIndex {
            $0.id == toDoItem.id
        }
        if let index = index {
            print("Updating Item: \(toDoItem)")
            toDoItems[index] = toDoItem
            createTodo(toDoItem: toDoItem)
        } else {
            print("Adding Item: \(toDoItem)")
            toDoItems.append(toDoItem)
            createTodo(toDoItem: toDoItem)
        }
        ///Sort as H M L
        toDoItems.sort(by: {
            switch $0.priority {
            case ToDoPriority.low:
                return false
            case ToDoPriority.medium:
                if $1.priority == ToDoPriority.low {
                    return true
                }
                else {
                    return false
                }
            case ToDoPriority.high:
                return true
            }
        })
        
        print("Saved item!")
        logItems()
        showingDetail = false
    }

    public func remove(toDoItem: ToDoItem) {
        if let index = toDoItems.firstIndex(of: toDoItem) {
            toDoItems.remove(at: index)
            print("Removed item!")
            logItems()
            showingDetail = false
            deleteTodo(toDoItem: toDoItem)
        }
    }

    public func remove(at indexSet: IndexSet) {
        for index in indexSet {
            let toDoItem = toDoItems[index]
            deleteTodo(toDoItem: toDoItem)
        }
        
        toDoItems.remove(atOffsets: indexSet)
        logItems()
    }
    
    /// Create a new Todo or update an existing Todo. DataStore uses id to decide.
    /// - Parameter toDoItem: What you want to create
    public func createTodo(toDoItem: ToDoItem) {
        Amplify.DataStore.save(toDoItem) { result in
                   switch(result) {
                   case .success(let savedItem):
                       print("Saved item: \(savedItem.text)")
                   case .failure(let error):
                       print("Could not save item to DataStore: \(error)")
                   }
                }
    }
    
    
    /// Delete a Todo
    /// - Parameter toDoItem: What you want to delete
    public func deleteTodo(toDoItem: ToDoItem) {
        ///Use type of the variable in query function, for example here, use ToDoItem. And we delete Todo using id equal. Where is the query parameter.
        Amplify.DataStore.query(ToDoItem.self,
                                where: ToDoItem.keys.id.eq(toDoItem.id)) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, let toDeleteTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                Amplify.DataStore.delete(toDeleteTodo) { result in
                    switch(result) {
                    case .success:
                        print("Deleted item: \(toDeleteTodo.text)")
                    case .failure(let error):
                        print("Could not update data in DataStore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
       }
    }
    
    ///Query all todo items in DataStore and put them into todoItems
    public func initTodo() {
        Amplify.DataStore.query(ToDoItem.self) { result in
               switch(result) {
               case .success(let todos):
                   for todo in todos {
                    toDoItems.append(todo)
                   }
               case .failure(let error):
                   print("Could not query DataStore: \(error)")
               }
           }
        toDoItems.sort(by: {
            switch $0.priority {
            case ToDoPriority.low:
                return false
            case ToDoPriority.medium:
                if $1.priority == ToDoPriority.low {
                    return true
                }
                else {
                    return false
                }
            case ToDoPriority.high:
                return true
            }
        })
    }
    
    public func disappearCompletedItems(showTime: Double) {
        for item in toDoItems {
            if let completedTime = item.completedAt {
                if (completedTime.foundationDate.timeIntervalSinceNow <= showTime) {
                remove(toDoItem: item)
                }
            }
        }
    }
    
    ///Update a Todo.
//    public func updateTodo(toDoItem: ToDoItem) {
//        ///First, query the original todo in the DataStore using id.
//        Amplify.DataStore.query(ToDoItem.self,
//                                where: ToDoItem.keys.id.eq(toDoItem.id)) { result in
//            switch(result) {
//            case .success(let todos):
//                guard todos.count == 1, var updatedTodo = todos.first else {
//                    print("Did not find exactly one todo, bailing")
//                    return
//                }
//                ///Modify the todo.
//                updatedTodo.text = "File quarterly taxes"
//                Amplify.DataStore.save(updatedTodo) { result in
//                    switch(result) {
//                    case .success(let savedTodo):
//                        print("Updated item: \(savedTodo.name)")
//                    case .failure(let error):
//                        print("Could not update data in DataStore: \(error)")
//                    }
//                }
//            case .failure(let error):
//                print("Could not query DataStore: \(error)")
//            }
//        }
//    }
    
//    public func remove(at index: Array<ToDoItem>.Index) {
//        toDoItems.remove(at: index)
//        logItems()
//    }
//
//    public func disappear(toDoItem: ToDoItem) {
//        let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: showTime))
////        RunLoop.main.schedule(after: _delay) {
//            if let index = self.toDoItems.firstIndex(of: toDoItem) {
//                if self.toDoItems[index].completed {
//                    self.toDoItems.remove(at: index)
//                }
//                print("Item disappear!")
//                self.logItems()
//            }
////        }
//    }
    
    private func logItems() {
        let items = toDoItems.map {
            String(describing: $0)
        }.joined(separator: "\n")
        print("Items: \(toDoItems.count)\n\(items)")
    }
}
