//
//  Logger.swift
//  Cork Weather
//
//  Created by Eddie Long on 07/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

public class Log {
    
    typealias LogHandlers = [LogHandler]
    
#if DEBUG
    private static var logLevel : LogLevel = .debug
#else
    private static var logLevel : LogLevel = .warning
#endif
    
    private static var tagFilters = [String]()
    private static var logHandlers = LogHandlers()
    public static var enableDefaultLogHandler = true
    private static let defaultLogHandler = DefaultLogHandler()
    
    public class func setLevel(_ level : LogLevel) {
        logLevel = level;
    }
    
    public class func getLevel() -> LogLevel {
        return logLevel
    }
    
    public class func setTagFilters(tags : [String]) {
        tagFilters = tags;
    }
    
    public class func addHandler(_ handler : LogHandler) {
        logHandlers.append(handler)
    }
    
    public class func removeHandler(_ handler : LogHandler) {
        logHandlers = logHandlers.filter() { $0 !== handler }
    }
    
    public class func hasHandler(_ handler : LogHandler) -> Bool {
        return !logHandlers.filter() { $0 === handler }.isEmpty
    }
    
    public class func log(message: String,
                   level: LogLevel = .debug,
                   tag: String = "",
                   extra : Any = NSNull.init(),
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        
        // Check log level
        if level.rawValue < logLevel.rawValue {
            return;
        }
        
        // Check filters
        if !tagFilters.isEmpty {
            
            // Ignore empty tags
            if tag.isEmpty {
                return
            }
            // Ignore tags not being asked for
            if !tagFilters.contains(tag) {
                return
            }
        }
        let line = LogLine.init(message: message, filename: fileName, funcName: funcName, line: line, column: column, extra: extra)
        if enableDefaultLogHandler {
            defaultLogHandler.logMessage(log: line, tag: tag, level: level)
        }
        // Now pass onto the handlers
        for handler in logHandlers {
            handler.logMessage(log: line, tag: tag, level: level)
        }
    }

    // Verbose
    public class func v(_ message: String,
                 _ tag: String = "",
                 extra : Any = NSNull.init(),
                 fileName: String = #file,
                 line: Int = #line,
                 column: Int = #column,
                 funcName: String = #function) {
        Log.log(message: message, level: .verbose, tag: tag, extra: extra, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    // Debug
    public class func d(_ message: String,
                 _ tag: String = "",
                 extra : Any = NSNull.init(),
                 fileName: String = #file,
                 line: Int = #line,
                 column: Int = #column,
                 funcName: String = #function) {
        Log.log(message: message, level: .debug, tag: tag, extra: extra, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    // Info
    public class func i(_ message: String,
                 _ tag: String = "",
                 extra : Any = NSNull.init(),
                 fileName: String = #file,
                 line: Int = #line,
                 column: Int = #column,
                 funcName: String = #function) {
        Log.log(message: message, level: .info, tag: tag, extra: extra, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    // Warning
    public class func w(_ message: String,
                 _ tag: String = "",
                 extra : Any = NSNull.init(),
                 fileName: String = #file,
                 line: Int = #line,
                 column: Int = #column,
                 funcName: String = #function) {
        Log.log(message: message, level: .warning, tag: tag, extra: extra, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    // Error
    public class func e(_ message: String,
                        _ tag: String = "",
                        extra : Any = NSNull.init(),
                        fileName: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcName: String = #function) {
        Log.log(message: message, level: .error, tag: tag, extra: extra, fileName: fileName, line: line, column: column, funcName: funcName)
    }

}
