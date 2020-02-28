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
}
