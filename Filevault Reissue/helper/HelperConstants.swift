//
//  HelperConstants.swift
//  com.github.cybertunnel.Filevault-Reissue.helper
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation

/// Constants used by the helper and referencing classes/objects
enum HelperConstants {
    /// The Priviledged Helper's folder where the helper would be normally installed
    static let helpersFolder = "/Library/PrivilegedHelperTools/"
    
    /// The helper domain
    static let domain = "com.github.cybertunnel.Enterprise-Migration-Assistant.helper"
    
    /// The helper's path
    static let helperPath = helpersFolder + domain
}
