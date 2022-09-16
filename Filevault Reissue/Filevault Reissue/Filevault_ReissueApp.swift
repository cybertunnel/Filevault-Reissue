//
//  Filevault_ReissueApp.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import SwiftUI

@main
struct Filevault_ReissueApp: App {
    
    /// Detects if Filevault is enabled on the machine
    var fvEnabled: Void = {
        let semaphore = DispatchSemaphore(value: 0)
        var task = Task.init {
            do {
                let result = try await ExecutionService.isFilevaultEnabled()
                
                if !result {
                    Log.write("Filevault is not enabled on this machine.", level: .error, category: .main)
                    exit(1)
                }
                else {
                    Log.write("Filevault is enabled on this machine, continuing", level: .info, category: .main)
                    semaphore.signal()
                }
            } catch {
                Log.write("Obtained an error of \(error.localizedDescription)", level: .error, category: .main)
            }
        }
        
        semaphore.wait()
    }()
    
    /// Attempts to reissue the key silently
    var silentReissue:Void = {
        /// Attempt to reissue the recovery key using the provided username(s) and password(s) from the command line
        
        /// Get usernames from command line
        guard let users = ArgParser.getAdminUsernames() else {
            return
        }
        
        /// Get passwords from command line
        guard let passwords = ArgParser.getAdminPasswords() else {
            return
        }
        
        /// Attempt to reissue the key silently
        Log.write("Attempting to automatically reissue Filevault recovery key using provided usernames and passwords.", level: .info, category: .main)
        for user in users {
            Log.write("Attempting to authenticate \"\(user)\" to Filevault to automatically reissue.", level: .debug, category: .main)
            for password in passwords {
                let semaphore = DispatchSemaphore(value: 0)
                let task = Task.init {
                    do {
                        let recKey = try await ExecutionService.reissueRecoveryKey(User(username: user, password: password))
                        print(recKey)
                        exit(0)
                    } catch {
                        Log.write("Obtained an error of \(error.localizedDescription)", level: .error, category: .main)
                    }
                    semaphore.signal()
                }
                
                semaphore.wait()
            }
        }
        return
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 600, height: 450, alignment: .center)
                .environmentObject(FilevaultController())
        }
    }
}
