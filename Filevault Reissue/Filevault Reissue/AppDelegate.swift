//
//  AppDelegate.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/27/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var storyboard: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
    private let fv = Filevault()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //  Check to see if Filevault is enabled
        if !Filevault.isFilevaultEnabled() {
            // Filevault is not enabled
            Log.write("Filevault is not enabled on this device!", level: .fault, category: .main)
            exit(1)
        }
        if self.autoReissue() {
            Log.write("Successfully reissued the recovery key automatically.", level: .info, category: .main)
            NSApp.terminate(self)
        }
        else {
            Log.write("Was not able to successfully reissue the recovery key, prompting user.", level: .info, category: .main)
            
            guard let promptWindow = NSStoryboard.main?.instantiateController(withIdentifier: "promptWindow") as? NSWindowController else {
                Log.write("Unable to load user prompt window controller!", level: .error, category: .main)
                return
            }
            
            //NSApp.runModal(for: promptWindow.window! as! MainWindow)
            NSApp.addWindowsItem(promptWindow.window! as! MainWindow, title: "Prompt", filename: false)
            NSApp.run()
            
            // Kills itself when the window is closed
            NSApp.terminate(self)
            
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    private func autoReissue() -> Bool {
        // Gets admin usernames from CLI arguments
        guard let users = ArgParser.getAdminUsernames() else {
            return false
        }
        
        // Gets admin passwords from CLI arguments
        guard let passwords = ArgParser.getAdminPasswords() else {
            return false
        }
        
        Log.write("Attempting to automatically reissue Filevault password using provided usernames and passwords.", level: .info, category: .main)
        for user in users {
            
            Log.write("Attempting to authenticate \"\(user)\" to Filevault to automatically reissue.", level: .debug, category: .main)
            for password in passwords {
                do {
                    let result = try fv.reissueRecoveryKey(user: user, password: password)
                    if result.successful {
                        Log.write("Successfully issued Filevault key of \(result.recoveryKey ?? "").", level: .info, category: .main)
                        return true
                    }
                    
                }
                catch Filevault.FilevaultError.UserNotEnabled {
                    Log.write("Was unable to reissue Filevault recovery key using user \"\(user)\"; they are not enabled for Filevault.", level: .fault, category: .main)
                }
                catch Filevault.FilevaultError.InvalidUsernameOrPassword {
                    Log.write("Was unable to reissue Filevault recovery key using user \"\(user)\"; wrong password for the user.", level: .fault, category: .main)
                }
                catch {
                    Log.write("Was unable to reissue Filevault recovery key using user \"\(user)\"; unknown reason", level: .fault, category: .main)
                }
            }
        }
        
        return false
    }

}

