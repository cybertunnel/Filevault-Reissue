//
//  FilevaultReissueError.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation

enum FilevaultReissueError: LocalizedError {
    case UserIsNotEnabled(user: String)
    case FilevaultNotEnabled
    case ReissueUnsuccessful
    case helperInstallation(String)
    case helperConnection(String)
    
    var errorDescription: String? {
        switch self {
        case .UserIsNotEnabled(let user): return "The user, \(user) is not enabled for filevault, please try a different user."
        case .FilevaultNotEnabled: return "Filevault is not enabled, unable to reissue recovery key."
        case .ReissueUnsuccessful: return "Was unable to successfully reissue recovery key, please review logs and try again."
        case .helperInstallation(let description): return "Helper installation error, \(description)"
        case .helperConnection(let description): return "Helper connection error. \(description)"
        }
    }
}
