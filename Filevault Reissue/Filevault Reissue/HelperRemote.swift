//
//  HelperRemote.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation
import XPC
import ServiceManagement

/**
 Handles the interaction and installation of the helper for this application
 */
struct HelperRemote {

    // MARK: - Properties

    /// Is the helper currently installed?
    var isHelperInstalled: Bool { FileManager.default.fileExists(atPath: HelperConstants.helperPath) }

    // MARK: - Functions

    /// Install the Helper in the privileged helper tools folder and load the daemon
    private func installHelper() throws {

        // try to get a valid empty authorisation
        var authRef: AuthorizationRef?
        var authStatus = AuthorizationCreate(nil, nil, [.preAuthorize], &authRef)

        guard authStatus == errAuthorizationSuccess else {
            throw FilevaultReissueError.helperInstallation("Unable to get a valid empty authorization reference to load Helper daemon")
        }

        // create an AuthorizationItem to specify we want to bless a privileged Helper
        let authItem = kSMRightBlessPrivilegedHelper.withCString { authorizationString in
            AuthorizationItem(name: authorizationString, valueLength: 0, value: nil, flags: 0)
        }

        // it's required to pass a pointer to the call of the AuthorizationRights.init function
        let pointer = UnsafeMutablePointer<AuthorizationItem>.allocate(capacity: 1)
        pointer.initialize(to: authItem)

        defer {
            // as we instantiate a pointer, it's our responsibility to make sure it's deallocated
            pointer.deinitialize(count: 1)
            pointer.deallocate()
        }

        // store the authorization items inside an AuthorizationRights object
        var authRights = AuthorizationRights(count: 1, items: pointer)

        let flags: AuthorizationFlags = [.interactionAllowed, .extendRights, .preAuthorize]
        authStatus = AuthorizationCreate(&authRights, nil, flags, &authRef)

        guard authStatus == errAuthorizationSuccess else {
            throw FilevaultReissueError.helperInstallation("Unable to get a valid loading authorization reference to load Helper daemon")
        }

        // Try to install the helper and to load the daemon with authorization
        var error: Unmanaged<CFError>?
        if SMJobBless(kSMDomainSystemLaunchd, HelperConstants.domain as CFString, authRef, &error) == false {
            let blessError = error!.takeRetainedValue() as Error
            throw FilevaultReissueError.helperInstallation("Error while installing the Helper: \(blessError.localizedDescription)")
        }

        // Helper successfully installed
        // Release the authorization, as mentioned in the doc
        AuthorizationFree(authRef!, [])
    }

    /// Creates the `NSXPCConnection` to be used to communicate to the helper
    private func createConnection() -> NSXPCConnection {
        let connection = NSXPCConnection(machServiceName: HelperConstants.domain, options: .privileged)
        connection.remoteObjectInterface = NSXPCInterface(with: HelperProtocol.self)
        connection.exportedInterface = NSXPCInterface(with: RemoteApplicationProtocol.self)
        connection.exportedObject = self

        connection.invalidationHandler = { [isHelperInstalled] in
            if isHelperInstalled {
                print("Unable to connect to Helper although it is installed")
            } else {
                print("Helper is not installed")
            }
        }

        connection.resume()

        return connection
    }

    /// Get the `NSXPCConnection` object
    private func getConnection() throws -> NSXPCConnection {
        if !isHelperInstalled {
            // we'll try to install the Helper if not already installed, but we need to get the admin authorization
            try installHelper()
        }
        return createConnection()
    }

    /// Get the remote helper object
    func getRemote() throws -> HelperProtocol {
        var proxyError: Error?

        // Try to get the helper
        let helper = try getConnection().remoteObjectProxyWithErrorHandler({ (error) in
            proxyError = error
        }) as? HelperProtocol

        // Try to unwrap the Helper
        if let unwrappedHelper = helper {
            return unwrappedHelper
        } else {
            throw FilevaultReissueError.helperConnection(proxyError?.localizedDescription ?? "Unknown error")
        }
    }
}
