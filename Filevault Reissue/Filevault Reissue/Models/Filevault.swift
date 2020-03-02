//
//  Filevault.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/28/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Foundation

class Filevault {
    
    enum FilevaultError: Error {
        case FilevaultNotEnabled
        case InvalidUsernameOrPassword
        case UserNotEnabled
    }
    struct ReissueResults {
        let successful: Bool
        let recoveryKey: String?
    }
    
    private func isUserAdded(_ user: String) -> Bool {
        
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
    
    internal func reissueRecoveryKey(user: String, password: String) throws -> ReissueResults {
        
        if !Filevault.isFilevaultEnabled() {
            throw FilevaultError.FilevaultNotEnabled
        }
        if !self.isUserAdded(user) {
            throw FilevaultError.UserNotEnabled
        }
        let process = Process()
        process.launchPath = "/usr/bin/fdesetup"
        process.arguments = ["changerecovery", "-personal", "-user", "\(user)", "-inputplist"]
        
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
                        <string>\(user)</string>
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
            let key = result?.components(separatedBy: " = ")[1]
            return ReissueResults(successful: true, recoveryKey: key)
        }
        else if result == "" && err?.contains("Unable to unlock or authenticate to FileVault") ?? false {
            throw FilevaultError.InvalidUsernameOrPassword
        }
        
        return ReissueResults(successful: false, recoveryKey: nil)
    }
    
    static func isFilevaultEnabled() -> Bool {
        
        let process = Process()
        process.launchPath = "/usr/bin/fdesetup"
        process.arguments = ["status"]
        
        let stdOut = Pipe()
        process.standardOutput = stdOut
        
        process.launch()
        let data = stdOut.fileHandleForReading.readDataToEndOfFile()
        let result = String(bytes: data, encoding: .utf8)
        if result?.contains("FileVault is On") ?? false {
            return true
        }
        else {
            return false
        }
    }
}
