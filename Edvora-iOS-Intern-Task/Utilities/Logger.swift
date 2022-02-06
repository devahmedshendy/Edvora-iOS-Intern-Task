//
//  Logger.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

final class Logger {
    
    struct LogLevel: CustomStringConvertible {
        
        static let info = LogLevel("Info")
        static let warning = LogLevel("Warning")
        static let error = LogLevel("Error")
        static let debug = LogLevel("Debug")
        
        let value: String
        
        var description: String {
            return value
        }
        
        init(_ value: String) {
            self.value = value
        }
    }
    
    struct MessageType: CustomStringConvertible {
        
        static let network = MessageType("Network")
        static let decoding = MessageType("Decoding")
        static let encoding = MessageType("Encoding")
        static let keychain = MessageType("Keychain")
        static let userdefaults = MessageType("UserDefaults")
        static let unknown = MessageType("Unknown")
        
        let value: String
        
        var description: String {
            return value
        }
        
        init(_ value: String) {
            self.value = value
        }
        
    }
    
    // MARK: - Logging Methods
    
    static func info(_ object: Any) {
        log(.info, object)
    }
    
    static func info(_ type: MessageType, _ object: Any) {
        log(.info, type, object)
    }
    
    static func debug(_ object: Any) {
        #if DEBUG
        log(.debug, object)
        #endif
    }
    
    static func debug(_ type: MessageType, _ object: Any) {
        #if DEBUG
        log(.warning, type, object)
        #endif
    }
    
    static func warning(_ object: Any) {
        log(.warning, object)
    }
    
    static func warning(_ type: MessageType, _ object: Any) {
        log(.warning, type, object)
    }
    
    static func error(_ object: Any) {
        log(.error, object)
    }
    
    static func error(_ type: MessageType, _ object: Any) {
        log(.error, type, object)
    }
    
    // MARK: - Helpers
    
    private static func log(_ level: LogLevel, _ object: Any) {
        print(">", level, "-", Date())
        print(">", object)
    }
    
    private static func log(_ level: LogLevel, _ type: MessageType, _ object: Any) {
        print(">", level, "-", type, "-", Date())
        print(">", object)
    }
}
