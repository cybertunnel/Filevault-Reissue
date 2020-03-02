//
//  ArgParser.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/27/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Parses the arguements provided this application.
 */

class ArgParser {
    /**
     Parses the usernames from the arguments and provides them back.
     - Returns: usernames as an array
     */
    static func getAdminUsernames() -> Array <String>? {
        let args = ProcessInfo.processInfo.arguments
        for arg in args {
            if arg.contains("--admin-usernames") {
                // Parses Admin Usernames
                let users = arg.components(separatedBy: "=")[1].components(separatedBy: ",")
                return users
            }
        }
        return nil
    }
    
    /**
     Parses the passwords from the arguments and provides them back.
     - Returns: passwords as an array
     */
    static func getAdminPasswords() -> Array <String>? {
        let args = ProcessInfo.processInfo.arguments
        for arg in args {
            if arg.contains("--admin-passwords") {
                // Parses Admin Passwords
                let passwords = arg.components(separatedBy: "=")[1].components(separatedBy: ",")
                return passwords
            }
        }
        return nil
    }
}
