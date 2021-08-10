// swiftlint:disable all
import Amplify
import Foundation

extension ToDoItem {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case priority
    case text
    case completedAt
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let toDoItem = ToDoItem.keys
    
    model.pluralName = "ToDoItems"
    
    model.fields(
      .id(),
      .field(toDoItem.priority, is: .required, ofType: .enum(type: ToDoPriority.self)),
      .field(toDoItem.text, is: .required, ofType: .string),
      .field(toDoItem.completedAt, is: .optional, ofType: .dateTime),
      .field(toDoItem.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(toDoItem.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}