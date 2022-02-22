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
    
    /**
     Copy the provided folder to the provided destination
     
     - Parameters:
        - src: The folder being copied as `URL`
        - dest: The place the folder is being copied to as `URL`
        - completion: What to do when data or errors are recieved as `(String?, Error?) -> Void`
     */
    static func copyFolder(from srcFolder: URL, to dstFolder: URL) async throws {
        if FileManager.default.fileExists(atPath: dstFolder.path) {
            logger.error("File \(dstFolder.path.debugDescription) already exists.")
            throw MigrationError.fileAlreadyExists
        } else {
            if FileManager.default.fileExists(atPath: srcFolder.path) {
                logger.debug("File/folder at \(srcFolder.path.debugDescription) is confirmed to exist, proceeding.")
                do {
                    try FileManager.default.copyItem(at: srcFolder, to: dstFolder)
                    return
                } catch {
                    logger.error("Error occurred while attempting to copy folder contents over. Error: \(error.localizedDescription, privacy: .public)")
                    throw error
                }
            } else {
                logger.error("Source file/folder at \(srcFolder.path.debugDescription, privacy: .public) does not exist.")
                throw MigrationError.fileDoesNotExist
            }
        }
    }
    
    /**
     Start the created launch daemon
     - Parameters:
        - completion: The handler for when this function completes as `(Result<String, Error>) -> Void`
     */
    static func startLaunchDaemon() async throws {
        let filePath = URL(fileURLWithPath: "/Library/LaunchDaemons/com.github.cybertunnel.Enterprise-Migration-Assistant.migratorTool.plist")
        if FileManager.default.fileExists(atPath: filePath.path) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            process.arguments = ["load", "-w", filePath.path]

            let outputPipe = Pipe()
            process.standardOutput = outputPipe
            process.standardError = outputPipe
            do {
                try process.run()
            } catch {
                return
            }
            process.waitUntilExit()
            return
        } else {
            return
        }
    }
    
    /**
     Create a launch daemon for the migrator tool at the provided path and arguments
     - Parameters:
        - path: The path of the migration tool as `String`
        - oldUser: The user's old account name as `String`
        - oldHome: The user's temporary migrated data folder path as `String`
        - oldPass: The user's password on their old device as `String`
        - user: The user that will be created as `String`
     */
    static func createLaunchDaemon(migratorToolPath path: String, withOldUser oldUser: String, withOldHome oldHome: String, withOldPass oldPass: String, forUser user: String) async throws {
        let filePath = URL(fileURLWithPath: "/Library/LaunchDaemons/com.github.cybertunnel.Enterprise-Migration-Assistant.migratorTool.plist")
        let contents = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>com.github.cybertunnel.Enterprise-Migration-Assistant.migratorTool</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(path)</string>
                <string>\(oldUser)</string>
                <string>\(oldHome)</string>
                <string>\(oldPass)</string>
                <string>\(user)</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
        </dict>
        </plist>
        """
        
        if FileManager.default.createFile(atPath: filePath.path, contents: contents.data(using: .utf8)) {
            return
        }
        else {
            // TODO: Add throwing
        }
        return
    }
    
    /**
     Create a migration user with the provided information using the provided credentials
     
     - Parameters:
        - username: The username for the migration user as `String`. Default: `migrator`
        - name: The full name of the migration user as `String`. Default: `Please Wait...`
        - password: The password for the migration account as `String`. Default: `migrationisfun`
        - adminUser: The username of the admin user being used to create this account as `String`
        - adminPass: The password for the admin user being used to create this account as `String`
        - completion: What to do when data or error is recieved as `(String?, Error?) -> Void`
     */
    static func makeMigratorUser(username: String, withName name: String, withPassword password: String, usingAdmin adminUser: String, withAdminPass adminPass: String) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/sysadminctl")
        process.arguments = ["-addUser", username, "-fullName", name, "-password", password, "-admin", "-adminUser", adminUser, "-adminPassword", adminPass]

        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = outputPipe
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus == 0 {
            return
        } else {
            // TODO: Add throwing
        }
        return
    }
}
