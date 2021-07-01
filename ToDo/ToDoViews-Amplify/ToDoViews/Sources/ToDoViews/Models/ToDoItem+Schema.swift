// swiftlint:disable all
import Amplify
import Foundation

extension ToDoItem {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case priority
    case text
    case completed
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let toDoItem = ToDoItem.keys
    
    model.pluralName = "ToDoItems"
    
    model.fields(
      .id(),
      .field(toDoItem.priority, is: .optional, ofType: .enum(type: ToDoPriority.self)),
      .field(toDoItem.text, is: .optional, ofType: .string),
      .field(toDoItem.completed, is: .optional, ofType: .bool)
    )
    }
}