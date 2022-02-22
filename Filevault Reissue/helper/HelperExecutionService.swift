//
//  HelperExecutionService.swift
//  com.github.cybertunnel.Filevault-Reissue.helper
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation
import OSLog

class HelperExecutionService {
    
    static let logger = Logger(subsystem: AppConstants.bundleIdentifier, category: "Helper Execution Service")
    
    static func isUserAdded(user: String) async -> Bool {
        logger.info("Checking if \(user.debugDescription, privacy: .public) is enabled for Filevault.")
        
        let process = Process()
        process.launchPath = "/usr/bin/fdesetup"
        process.arguments = ["list"]
        
        let stdOut = Pipe()
        process.standardOutput = stdOut
        
        process.launch()
        let data = stdOut.fileHandleForReading.readDataToEndOfFile()
        let result = String(bytes: data, encoding: .utf8)
        let users = result?.components(separatedBy: "\n").dropLast().map { $0.components(separatedBy: ",")[0] }
        if users?.contains(user) ?? false {
            return true
        }
        else {
            return false
        }
    }
    
    static func reissueRecoveryKey(username: String, password: String) async throws -> String {
        logger.info("Attempting to reissue Filevault recovery key for user \(username, privacy: .public)")
        
        if !(await isFilevaultEnabled()) {
            logger.fault("Filevault is not enabled!")
            throw FilevaultReissueError.FilevaultNotEnabled
        }
        if !(await isUserAdded(user: username)) {
            logger.fault("User \(username, privacy: .public) is not enabled for Filevault!")
            throw FilevaultReissueError.UserIsNotEnabled(user: username)
        }
        let process = Process()
        process.launchPath = "/usr/bin/fdesetup"
        process.arguments = ["changerecovery", "-personal", "-user", "\(username)", "-inputplist"]
        
        let stdOut = Pipe()
        process.standardOutput = stdOut
        
        let stdErr = Pipe()
        process.standardError = stdErr
        
        let stdIn = Pipe()
        process.standardInput = stdIn
        
        let string = """
        <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                    <dict>
                        <key>Username</key>
                        <string>\(username)</string>
                        <key>Password</key>
                        <string>\(password)</string>
                    </dict>
                </plist>
        """
        
        stdIn.fileHandleForWriting.write(string.data(using: .utf8)!)
        stdIn.fileHandleForWriting.closeFile()
        
        process.launch()
        
        let data = stdOut.fileHandleForReading.readDataToEndOfFile()
        let result = String(bytes: data, encoding: .utf8)
        
        let errData = stdErr.fileHandleForReading.readDataToEndOfFile()
        let err = String(bytes: errData, encoding: .utf8)
        
        if result?.contains("New personal recovery key") ?? false {
            logger.info("Successfully reissued recovery key.")
            let key = result?.components(separatedBy: " = ")[1]
            return key ?? ""
        }
        else if result == "" && err?.contains("Unable to unlock or authenticate to FileVault") ?? false {
            logger.fault("Username and/or password provided are an invalid combination.")
            throw FilevaultReissueError.ReissueUnsuccessful
        }
        
        // Cover all cases, return false
        throw FilevaultReissueError.ReissueUnsuccessful
    }
    
    static func isFilevaultEnabled() async -> Bool {
        logger.info("Checking if Filevault is enabled.")
        let process = Process()
        process.launchPath = "/usr/bin/fdesetup"
        process.arguments = ["status"]
        
        let stdOut = Pipe()
        process.standardOutput = stdOut
        
        process.launch()
        let data = stdOut.fileHandleForReading.readDataToEndOfFile()
        let result = String(bytes: data, encoding: .utf8)
        if result?.contains("FileVault is On") ?? false {
            logger.info("Filevault is enabled.")
            return true
        }
        else {
            logger.info("Filevault is not enabled.")
            return false
        }
    }
    
}
