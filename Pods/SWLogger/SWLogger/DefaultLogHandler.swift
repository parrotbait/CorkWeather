//
//  DefaultLogHandler.swift
//  Cork Weather
//
//  Created by Eddie Long on 07/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

public class DefaultLogHandler : LogHandler {
    
    private static var logFile : Bool = false
    private static var logFunc : Bool = false
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    public static func logFileDetails(_ enable : Bool) {
        logFile = enable
    }
    
    public static func logFunc(_ enable : Bool) {
        logFunc = enable
    }

    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    private func logLevelText(_ event : LogLevel) -> String {
        switch event {
            
        case .silent: return ""
        case .verbose: return "🔬"
        case .debug: return "💬"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .severe: return "🔥"
        case .error: return "‼️"
        }
    }
    
    private func getTag(_ tag : String) -> String {
        if tag.isEmpty {
            return ""
        }
        return " [\(tag)]"
    }
    
    private func getFileString(log: LogLine) -> String {
        var fileString = ""
        if (DefaultLogHandler.logFile) {
            fileString += " \(sourceFileName(filePath: log.filename)):\(log.line)"
        }
        if (DefaultLogHandler.logFunc) {
             fileString += " \(log.funcName)"
        }
        if !fileString.isEmpty {
            fileString += " "
        }
        return fileString
    }
    
    public func logMessage(log: LogLine, tag: String, level: LogLevel) {
        let datetime = DefaultLogHandler.dateFormatter.string(from: Date())
        print("\(datetime) \(logLevelText(level))\(getTag(tag)) -\(getFileString(log: log)) \(log.message)")
    }
}
