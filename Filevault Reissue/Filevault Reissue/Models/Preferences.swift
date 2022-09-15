//
//  Preferences.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/28/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Foundation

class Preferences {
    
    static let sharedInstance = Preferences()
    private let userDefaults: UserDefaults
    
    /// The title displayed on main window
    internal var viewTitle: String? {
        get {
            return self.userDefaults.string(forKey: "viewTitle")
        }
    }
    
    /// Instruction text displayed on the main window
    internal var viewInstructions: String? {
        get {
            return self.userDefaults.string(forKey: "viewInstructions")
        }
    }
    
    /// The path to the company's logo
    internal var viewLogoPath: String? {
        get {
            return self.userDefaults.string(forKey: "viewLogoPath")
        }
    }
    
    /// The text displayed when user wants more information on this program
    internal var infoURL: String? {
        get {
            return self.userDefaults.string(forKey: "infoURL")
        }
    }
    
    /// If the recovery key should be present to user upon completion
    internal var suppressRecoveryKey: Bool {
        get {
            return self.userDefaults.bool(forKey: "suppressRecoveryKey")
        }
    }
    
    /// If an alert should be presented to the user if the user successfully authenticates
    internal var successAlert: Bool {
        get {
            return self.userDefaults.bool(forKey: "successAlert")
        }
    }
    
    /// Message text presented to user upon successful completion
    internal var successKeyMessage: String? {
        get {
            return self.userDefaults.string(forKey: "successKeyMessage")
        }
    }
    
    /// Placeholder used for the username field for the main window
    internal var usernamePlaceholder: String? {
        get {
            return self.userDefaults.string(forKey: "usernamePlaceholder")
        }
    }
    
    /// Placeholder used for the password field for the main window
    internal var passwordPlaceholder: String? {
        get {
            return self.userDefaults.string(forKey: "passwordPlaceholder")
        }
    }
    
    /// Text presented to the user when they request more information
    internal var moreInformationText: String? {
        get {
            return self.userDefaults.string(forKey: "moreInformationText")
        }
    }
    
    init(nsUserDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = nsUserDefaults
    }
    
    init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }
}
