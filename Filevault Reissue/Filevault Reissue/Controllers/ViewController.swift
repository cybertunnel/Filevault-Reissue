//
//  ViewController.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/27/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // MARK: Outlets
    @IBOutlet weak var viewTitle: NSTextField!
    @IBOutlet weak var viewInstructions: NSTextField!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var infoBtn: NSButton!
    @IBOutlet weak var submitBtn: NSButton!
    @IBOutlet weak var errorLabel: NSTextField!
    @IBOutlet weak var logo: NSImageView!
    
    // MARK: Variables
    private var running: Bool = false {
        willSet(newValue) {
            DispatchQueue.main.async {
                self.usernameField.isEnabled = !newValue
                self.passwordField.isEnabled = !newValue
                self.submitBtn.isEnabled = !newValue
            }
        }
    }

    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.global(qos: .background).async {
            while true {
                DispatchQueue.main.async {
                    Log.write("Bringing window to the front.", level: .debug, category: .view)
                    self.view.window?.orderFrontRegardless()
                }
                sleep(120)
            }
        }
        
        // Load View using Preferences
        if let prefTitle = Preferences.sharedInstance.viewTitle {
            // Update title to one in preferences
            self.viewTitle.stringValue = prefTitle
        }
        
        if let prefInstructions = Preferences.sharedInstance.viewInstructions {
            // Update instructions to one in preferences
            self.viewInstructions.stringValue = prefInstructions
        }
        
        // Update placeholder text to the ones stored in preferences
        self.usernameField.placeholderString = Preferences.sharedInstance.usernamePlaceholder
        self.passwordField.placeholderString = Preferences.sharedInstance.passwordPlaceholder
        
        if let logoPath = Preferences.sharedInstance.viewLogoPath {
            // Update logo to on provided in preferences
            if FileManager.default.fileExists(atPath: logoPath) {
                let img = NSImage(byReferencingFile: logoPath)
                self.logo.image = img
            }
            else {
                Log.write("Provided logo path does not exist, unable to set logo to provided file.", level: .fault, category: .view)
            }
        }
    }
    
    // MARK: IB Actions
    @IBAction func submitBtnPressed(_ sender: NSButton) {
        
        Log.write("User has submitted their information, attempting to build objects and reissue recovery key.", level: .info, category: .view)
        self.running = true
        
        let fv = Filevault()
        
        // Create user object for Non-Main thread.
        let userObj = User(username: self.usernameField.stringValue, password: self.passwordField.stringValue)
        
        // Run in background to free up main thread for UI
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Attempt to reissue Filevault key using provided username and password from user
                let results = try fv.reissueRecoveryKey(user: userObj.username, password: userObj.password)
                self.running = false
                
                if results.successful {
                    // Successful, shows user the new recovery key
                    
                    DispatchQueue.main.async {
                        if !Preferences.sharedInstance.supressRecoveryKey {
                            Log.write("Successfully reissued recovery key using provided credentials, providing the user with the new recovery key.", level: .info, category: .view)
                            let alert = NSAlert()
                                alert.alertStyle = .informational
                                alert.icon = NSImage.init(named: NSImage.menuOnStateTemplateName)
                            
                                alert.messageText = "Successfully Reissued Recovery Key"
                                alert.informativeText = "Successfully reissued the recovery key on this machine.\nNew recovery key: \(String(describing: results.recoveryKey ?? ""))"
                                alert.beginSheetModal(for: self.view.window!) { _ in
                                    Log.write("User has closed the recovery key window.", level: .info, category: .view)
                                    self.view.window?.close()
                                    NSApp.terminate(self)
                            }
                        }
                        else {
                            Log.write("Successfully reissued recovery key using provided credentials, user prompt with the new key is supressed.", level: .info, category: .view)
                            self.view.window?.close()
                            NSApp.terminate(self)
                        }
                    }
                }
            }
            catch Filevault.FilevaultError.InvalidUsernameOrPassword {
                Log.write("User provided an invalud username or password, alerting them.", level: .error, category: .view)
                Log.write("User provided a username of \"\(userObj.username)\".", level: .debug, category: .view)
                DispatchQueue.main.async {
                    self.errorLabel.stringValue = "Invalid username or password, please try again."
                    self.errorLabel.isHidden = false
                    self.running = false
                }
            }
            catch Filevault.FilevaultError.UserNotEnabled {
                Log.write("User provided a user that is not enabled for Filevault, alerting them.", level: .error, category: .view)
                Log.write("User provided a username value of \"\(userObj.username)\".", level: .debug, category: .view)
                DispatchQueue.main.async {
                    
                    // Is this a security risk?
                    self.errorLabel.stringValue = "Invalid username or password, or the user is not enabled for Filevault."
                    self.errorLabel.isHidden = false
                    self.running = false
                }
            }
            catch {
                Log.write("An unknown error occurred!", level: .error, category: .view)
                self.running = false
            }
        }
        
    }
    
    @IBAction func infoBtnPressed(_ sender: NSButton) {
        Log.write("User has requested for more information around this prompt, showing them provided information.", level: .info, category: .view)
        guard let vc = self.storyboard?.instantiateController(withIdentifier: "infoViewController") as? InformationViewController else {
            Log.write("Error occurred while attempting to get the informational view controller.", level: .fault, category: .view)
            return
        }
        self.presentAsSheet(vc)
        
    }


}

