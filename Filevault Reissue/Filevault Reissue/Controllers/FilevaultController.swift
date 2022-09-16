//
//  FilevaultController.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Handles the reissuing of Filevault keys and calls the helper binary if needed
 */
class FilevaultController: ObservableObject {
    /// User data that would be used to reissue the recovery key
    @Published var user: User
    /// The new key if one is provided back
    @Published var newKey: String?
    /// Should the info pane be displayed
    @Published var showInfo: Bool = false
    /// Should show a successful reissue
    @Published var showSuccess: Bool = false
    /// Error message, if one was obtained during reissue
    @Published var errorMsg: String? = nil
    /// Detect if the reissue is in progress
    @Published var inProgress: Bool = false
    
    init(user: User? = nil) {
        guard let user = user else {
            self.user = User(username: "", password: "")
            return
        }
        self.user = user
    }
    
    /**
     Initializes the controller with the provided username and password. This should only be done for silent reissuing of keys.
     
     - Parameters
        - username: The username that is used in `fdesetup`
        - password: The password of the user used to authenticate to `fdesetup`
     */
    convenience init(username: String?, password: String?) {
        if let username = username, let password = password {
            let user = User(username: username, password: password)
            self.init(user: user)
        } else {
            self.init()
        }
    }
    
    /**
     Attempts to reissue the key while setting the inprogress value to true and then false once reissue is completed.
     */
    func reissueKey() {
        DispatchQueue.main.async {
            self.inProgress = true
        }
        Task.init {
            do {
                let recKey = try await ExecutionService.reissueRecoveryKey(self.user)
                print(recKey)
                DispatchQueue.main.async {
                    self.newKey = recKey
                    self.showSuccess.toggle()
                    self.inProgress = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMsg = error.localizedDescription
                    self.inProgress = false
                }
            }
        }
    }
}
