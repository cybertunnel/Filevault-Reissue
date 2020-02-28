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
    
    private func isUserAdded(_ user: String) -> Bool {
        return false
    }
    
    internal func reissueRecoveryKey(user: String, password: String) -> Any? {
        return nil
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
        print(result)
        if result?.contains("FileVault is On") ?? false {
            return true
        }
        else {
            return false
        }
        
        return false
    }
}
