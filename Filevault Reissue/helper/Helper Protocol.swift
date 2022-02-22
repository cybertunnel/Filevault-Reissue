//
//  Helper Protocol.swift
//  com.github.cybertunnel.Filevault-Reissue.helper
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation

@objc(HelperProtocol)
public protocol HelperProtocol {
    @objc func isFilevaultEnabled() async throws -> Bool
    @objc func isUserAdded(user: String) async throws -> Bool
    @objc func reissueRecoveryKey(username: String, password: String) async throws -> String
    @objc func version() async -> String
}
