import Amplify
import Foundation

/// Maintain all Todo information used in each view.
public class ToDoEnvironment: ObservableObject {
    ///Control ToDoItemDetail show or not. Used in ToDoList and ToDoItemDetail.
    @Published var showingDetail: Bool = false
    ///Store ToDoItems
    @Published var toDoItems: ToDoItems = []
    ///Store current Todo item information. Display in ToDoItemDetail.
    @Published var selectedToDoItem: ToDoItem? = nil

    public init() {}
    
    /// Check id to know whether the item is in the todoItems, then determine update or add.
    /// - Parameter toDoItem: New one from ToDoItemDetail through Save button.
    public func saveToDoItem(toDoItem: ToDoItem) {
        let index = toDoItems.firstIndex {
            $0.id == toDoItem.id
        }
        
        if let index = index {
            print("Updating Item: \(toDoItem)")
            toDoItems[index] = toDoItem
            create(item: toDoItem)
        } else {
            print("Adding Item: \(toDoItem)")
            toDoItems.append(toDoItem)
            create(item: toDoItem)
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
    
    
    ///Query all todo items in DataStore and put them into todoItems
    public func initTodo() {
        let todos = queryAll(type: ToDoItem())
        for todo in todos {
            toDoItems.append(todo)
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
    
    public func remove(toDoItem: ToDoItem) {
        if let index = toDoItems.firstIndex(of: toDoItem) {
            toDoItems.remove(at: index)
            print("Removed item!")
            logItems()
            showingDetail = false
            delete(item: toDoItem)
        }
    }
    
    public func remove(at indexSet: IndexSet) {
        for index in indexSet {
            let toDoItem = toDoItems[index]
            delete(item: toDoItem)
        }
        
        toDoItems.remove(atOffsets: indexSet)
        logItems()
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
    
    /// Create a new item or update an existing item. DataStore uses id to decide.
    /// - Parameter Item: An item to be created which must follows the schema.graphql.
    public func create<T: Model>(item: T) {
        Amplify.DataStore.save(item) { result in
                   switch(result) {
                   case .success(let savedItem):
                    print("Saved item: \(savedItem.self)")
                   case .failure(let error):
                       print("Could not save item to DataStore: \(error)")
                   }
                }
    }

    /// Query one item according to the query parameter in DataStore and return it
    /// - Parameters:
    ///   - type: Any item following the schema.graphql
    ///   - queryConditon: Query parameter. For example, ToDoItem.keys.id.eq(toDoItem.id)
    /// - Returns: An optional item
    public func query<T: Model>(type: T, queryConditon: QueryPredicate?) -> T? {
        var item: T? = nil
        /// And we delete Todo using id equal. 'Where' is the query parameter, here is to query the item with the same id of item.
        Amplify.DataStore.query(T.self, where: queryConditon) { result in
            switch(result) {
            case .success(let outputs):
                guard outputs.count == 1, let output = outputs.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                item = output
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return item
    }

    /// Query all items in DataStore and return them
    /// - Parameter type: Any item following the schema.graphql
    /// - Returns: Array of items
    public func queryAll<T: Model>(type: T) -> [T] {
        var items: [T] = []
        Amplify.DataStore.query(T.self) { result in
               switch(result) {
               case .success(let todos):
                   items = todos
               case .failure(let error):
                   print("Could not query DataStore: \(error)")
               }
           }
        return items
    }

    /// Delete an item
    /// - Parameter Item: An item to be created which must follows the schema.graphql.
    public func delete<T: Model>(item: T) {
        Amplify.DataStore.delete(item) { result in
            switch(result) {
            case .success:
                print("Deleted item: \(item.self)")
            case .failure(let error):
                print("Could not delete data in DataStore: \(error)")
            }
        }
    }
    
    private func logItems() {
        let items = toDoItems.map {
            String(describing: $0)
        }.joined(separator: "\n")
        print("Items: \(toDoItems.count)\n\(items)")
    }
}
