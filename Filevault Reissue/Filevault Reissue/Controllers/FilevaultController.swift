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
}
