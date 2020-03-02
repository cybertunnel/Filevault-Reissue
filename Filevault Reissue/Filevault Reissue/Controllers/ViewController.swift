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
                    
                    Log.write("Successfully reissued recovery key using provided credentials, providing the user with the new recovery key.", level: .info, category: .view)
                    DispatchQueue.main.async {
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
    }


}

