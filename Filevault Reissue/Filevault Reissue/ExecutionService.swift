//
//  ExecutionService.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation
import OSLog

/**
 Execution object to help abstract the underlying functions and the calls out to the helper.
 - SeeAlso: `HelperExecutionService` and `ToolExecutionService`
 */
struct ExecutionService {
    
    // MARK: - Constants
    
    @available(macOS 11.0, *)
    static let logger = Logger(subsystem: AppConstants.bundleIdentifier, category: "Execution Service")
    
    
    // MARK: - Functions
    
    /**
     Check if the provided user is added to Filevault.
     - Parameters:
        - user: The user to be checked if they are added to Filevault as `String`
     - Throws `FilevaultReissueError` if there is an issue with the helper
     - Returns True if user is enabled, false if the user is not enabled
     */
    static func isUserAdded(_ user: String) async throws -> Bool {
        let remote = try HelperRemote().getRemote()
        
        let result = try await remote.isUserAdded(user: user)
        
        return result
    }
    
    /**
     Check if Filevault is enabled on the device
     - Throws `FilevaultReissueError` if there is an issue with the helper
     - Returns True if Filevault is enabled, and false if Filevault is not enabled
     */
    static func isFilevaultEnabled() async throws -> Bool {
        let remote = try HelperRemote().getRemote()
        
        let result = try await remote.isFilevaultEnabled()
        
        return result
    }
    
    /**
     Reissue the recovery key using the provided username and password
     - Parameters user as `User` object which contains a username and password
     - Throws `FilevaultReissueError` if there is an issue with the helper
     - Returns The new recovery key
     */
    static func reissueRecoveryKey(_ user: User) async throws-> String {
        let remote = try HelperRemote().getRemote()
        let result = try await remote.reissueRecoveryKey(username: user.username, password: user.password)
        
        return result
        
        
    }
}
