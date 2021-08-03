import Foundation

/// Log levels are modeled as Ints to allow for easy comparison of levels
public enum LogLevel: Int {
    case error
    case warn
    case info
    case debug
    case verbose
}

extension LogLevel: Comparable {
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

public protocol Logger: AnyObject {
    
    /// The log level of the logger.
    var logLevel: LogLevel { get }
    
    /// Logs a message at `error` level
    func error(_ message: @autoclosure () -> String)
    
    /// Logs the error at `error` level
    func error(error: Error)
    
    /// Logs a message at `warn` level
    func warn(_ message: @autoclosure () -> String)
    
    /// Logs a message at `info` level
    func info(_ message: @autoclosure () -> String)
    
    /// Logs a message at `debug` level
    func debug(_ message: @autoclosure () -> String)
    
    /// Logs a message at `verbose` level
    func verbose(_ message: @autoclosure () -> String)
}

public class DefaultLogger: Logger {
    public let logLevel: LogLevel
    
    public init(logLevel: LogLevel = .debug) {
        self.logLevel = logLevel
    }
    
    /// Logs a message at `error` level
    public func error(_ message: @autoclosure () -> String) {
        print(message())
    }
    
    /// Logs the error at `error` level
    public func error(error: Error) {
        print("Error: \(error)")
    }
    
    /// Logs a message at `warn` level
    public func warn(_ message: @autoclosure () -> String) {
        print(message())
    }
    
    /// Logs a message at `info` level
    public func info(_ message: @autoclosure () -> String) {
        print(message())
    }
    
    /// Logs a message at `debug` level
    public func debug(_ message: @autoclosure () -> String) {
        print(message())
    }
    
    /// Logs a message at `verbose` level
    public func verbose(_ message: @autoclosure () -> String) {
        print(message())
    }
    
}
