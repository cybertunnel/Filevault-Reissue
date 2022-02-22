//
//  FilevaultController.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import Foundation

class FilevaultController: ObservableObject {
    @Published var user: User
    @Published var newKey: String?
    @Published var showInfo: Bool = false
    @Published var showSuccess: Bool = false
    @Published var errorMsg: String? = nil
    @Published var inProgress: Bool = false
    
    init(user: User? = nil) {
        guard let user = user else {
            self.user = User(username: "", password: "")
            return
        }
        self.user = user
    }
    convenience init(username: String?, password: String?) {
        if let username = username, let password = password {
            let user = User(username: username, password: password)
            self.init(user: user)
        } else {
            self.init()
        }
    }
    
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
