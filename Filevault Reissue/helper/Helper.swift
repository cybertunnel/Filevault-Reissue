//
//  Helper.swift
//  com.github.cybertunnel.Filevault-Reissue.helper
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation
import OSLog

/**
 Privileged helper for handling elevated tasks
 */
class Helper: NSObject, NSXPCListenerDelegate, HelperProtocol {
    
    /// Logging object
    private let logger = Logger(subsystem: AppConstants.bundleIdentifier, category: "Migration Helper")
    func version() async -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }
    
    //  MARK: - Properties
    
    /// The spy
    let listener: NSXPCListener
    
    // MARK: - Initialisation
    
    override init() {
        self.listener = NSXPCListener(machServiceName: HelperConstants.domain)
        super.init()
        self.listener.delegate = self
    }
    
    // MARK: - Functions // MARK: HelperProtocol
    func isFilevaultEnabled() async throws -> Bool {
        return await HelperExecutionService.isFilevaultEnabled()
    }
    
    func isUserAdded(user: String) async throws -> Bool {
        return await HelperExecutionService.isUserAdded(user: user)
    }
    
    func reissueRecoveryKey(username: String, password: String) async throws -> String {
        return try await HelperExecutionService.reissueRecoveryKey(username: username, password: password)
    }
    
    // TODO: Add proper functions
    
    /// Run the helper
    func run() {
        //  Start listening on new connections
        self.listener.resume()
        // prevent the terminal application from exiting
        RunLoop.current.run()
    }
    
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
        newConnection.remoteObjectInterface = NSXPCInterface(with: RemoteApplicationProtocol.self)
        newConnection.exportedObject = self

        newConnection.resume()

        return true
    }
}
