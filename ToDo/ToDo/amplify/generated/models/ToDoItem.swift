// swiftlint:disable all
import Amplify
import Foundation

public struct ToDoItem: Model {
  public let id: String
  public var priority: ToDoPriority
  public var text: String
  public var completedAt: Temporal.DateTime?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      priority: ToDoPriority,
      text: String,
      completedAt: Temporal.DateTime? = nil) {
    self.init(id: id,
      priority: priority,
      text: text,
      completedAt: completedAt,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      priority: ToDoPriority,
      text: String,
      completedAt: Temporal.DateTime? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.priority = priority
      self.text = text
      self.completedAt = completedAt
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}