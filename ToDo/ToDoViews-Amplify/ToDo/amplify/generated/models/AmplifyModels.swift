// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "78627182a52c610d6818cf113142f68e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ToDoItem.self)
  }
}