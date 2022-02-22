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
        
        return false
    }
    
    internal func reissueRecoveryKey(user: String, password: String) throws -> ReissueResults {
        
        Log.write("Attempting to reissue Filevault recovery key for user \(user).", level: .info, category: .filevault)
        
        if !Filevault.isFilevaultEnabled() {
            Log.write("Filevalt is not enabled!", level: .fault, category: .filevault)
            throw FilevaultError.FilevaultNotEnabled
        }
        if !self.isUserAdded(user) {
            Log.write("User provided is not enabled for Filevault!", level: .fault, category: .filevault)
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
            Log.write("Successfully was able to reissue recovery key.", level: .info, category: .filevault)
            let key = result?.components(separatedBy: " = ")[1]
            return ReissueResults(successful: true, recoveryKey: key)
        }
        else if result == "" && err?.contains("Unable to unlock or authenticate to FileVault") ?? false {
            Log.write("Username and/or password provided are an invalid combination.", level: .fault, category: .filevault)
            throw FilevaultError.InvalidUsernameOrPassword
        }
        
        // Cover all cases, return false
        return ReissueResults(successful: false, recoveryKey: nil)
    }
    
    static func isFilevaultEnabled() -> Bool {
        
        Log.write("Checking if Filevault is enabled.", level: .info, category: .filevault)
        let process = Process()
        process.launchPath = "/usr/bin/fdesetup"
        process.arguments = ["status"]
        
        let stdOut = Pipe()
        process.standardOutput = stdOut
        
        process.launch()
        let data = stdOut.fileHandleForReading.readDataToEndOfFile()
        let result = String(bytes: data, encoding: .utf8)
        if result?.contains("FileVault is On") ?? false {
            Log.write("Filevault is enabled.", level: .info, category: .filevault)
            return true
        }
        else {
            Log.write("Filevault is not enabled.", level: .info, category: .filevault)
            return false
        }
    }
}
