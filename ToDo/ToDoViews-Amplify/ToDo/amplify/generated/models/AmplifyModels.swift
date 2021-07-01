// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "2bf6c12d18b806fa6430b74cd0ff6073"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ToDoItem.self)
  }
}