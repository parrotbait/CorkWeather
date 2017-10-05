//
//  DefaultFileHandler.swift
//  Pods
//
//  Created by Eddie Long on 02/10/2017.
//
//

import Foundation

public class DefaultFileHandler  : LogHandler {
    
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
    
    var fileDateFormat = "yyyy-MM-dd-hh-mm-ssSSS"
    var fileDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = fileDateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }

    private var fileHandle : FileHandle?
    
    public static func logFileDetails(_ enable : Bool) {
        logFile = enable
    }
    
    public static func logFunc(_ enable : Bool) {
        logFunc = enable
    }
    
    public init() {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileName = fileDateFormatter.string(from: Date()) + ".log"
            let fileURL = dir.appendingPathComponent(fileName)
            
            if (FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)) {
                fileHandle = try? FileHandle(forWritingTo: fileURL)
            }
        }
    }
    
    deinit {
        if let handler = fileHandle {
            handler.closeFile()
        }
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
        if (DefaultFileHandler.logFile) {
            fileString += " \(sourceFileName(filePath: log.filename)):\(log.line)"
        }
        if (DefaultFileHandler.logFunc) {
            fileString += " \(log.funcName)"
        }
        if !fileString.isEmpty {
            fileString += " "
        }
        return fileString
    }
    
    public func logMessage(log: LogLine, tag: String, level: LogLevel) {
        if let handle = fileHandle {
            let datetime = DefaultLogHandler.dateFormatter.string(from: Date())
            let finalString = "\(datetime) \(logLevelText(level))\(getTag(tag)) -\(getFileString(log: log)) \(log.message)\n"
            handle.write(finalString.data(using: String.Encoding.utf8)!)
        }
        
    }
}
