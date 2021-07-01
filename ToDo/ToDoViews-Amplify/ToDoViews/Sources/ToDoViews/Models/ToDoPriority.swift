// swiftlint:disable all
import Amplify
import Foundation

/// Priority of Todo item.
public enum ToDoPriority: String, EnumPersistable {
  case low
  case medium
  case high
}
