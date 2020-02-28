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
            NSApp.terminate(self)
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
            
            NSApp.runModal(for: promptWindow.window! as! MainWindow)
            
            NSApp.terminate(self)
            
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    private func autoReissue() -> Bool {
        guard let users = ArgParser.getAdminUsernames() else {
            return false
        }
        guard let passwords = ArgParser.getAdminPasswords() else {
            return false
        }
        
        for user in users {
            for password in passwords {
                // TODO: Provide a validation it worked
                fv.reissueRecoveryKey(user: user, password: password)
            }
        }
        
        return false
    }

}

