// swiftlint:disable all
import Amplify
import Foundation

public struct ToDoItem: Model {
  public let id: String
  public var priority: ToDoPriority
  public var text: String
  public var completedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      priority: ToDoPriority,
      text: String,
      completedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.priority = priority
      self.text = text
      self.completedAt = completedAt
  }
}