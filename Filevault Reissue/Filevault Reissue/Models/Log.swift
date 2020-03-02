//
//  Log.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/28/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Foundation
import os.log

/**
 Class that handles Log management.
 */
class Log {
    enum Level: UInt8 {
        case debug = 2, fault = 17, error = 16, info = 1
    }
    enum Category: String {
        case main = "MAIN", filevault = "Filevault", view = "View", window = "Window", preferences = "Preferences", parser = "ArgumentParser"
    }
    
    static let appName = "com.comcast.cable.cis.Filevault-Reissue"
    
    /**
     Writes the provided information to the log.
     - Parameters:
     */
    static func write(_ string: String, level: Level, category: Category) -> Void {
        let log = OSLog(subsystem: appName, category: category.rawValue)
        os_log("%{public}@", log: log, type: OSLogType(level.rawValue), string)
    }
}

