// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b64f3a8681756239e0debc0d2bc1a5e4"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ToDoItem.self)
  }
}