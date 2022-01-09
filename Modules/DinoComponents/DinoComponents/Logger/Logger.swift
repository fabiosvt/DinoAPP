//
//  Logger.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import Foundation

public enum LoggingType: String {
    case error = "Error: "
    case info = "Info: "
    case warning = "Warning: "
}

public class Logger {
    public init() {}
    
    public func log(message: String, type: LoggingType) {
        print("\(type.rawValue)\(message)")
    }
}
