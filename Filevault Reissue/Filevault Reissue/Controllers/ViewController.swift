//
//  ViewController.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 2/27/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var viewTitle: NSTextField!
    @IBOutlet weak var viewInstructions: NSTextField!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var infoBtn: NSButton!
    @IBOutlet weak var submitBtn: NSButton!
    @IBOutlet weak var errorLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.global(qos: .background).async {
            while true {
                DispatchQueue.main.async {
                    self.view.window?.orderFrontRegardless()
                }
                sleep(120)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: NSButton) {
        let fv = Filevault()
        let userObj = User(username: self.usernameField.stringValue, password: self.passwordField.stringValue)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let results = try fv.reissueRecoveryKey(user: userObj.username, password: userObj.password)
                if results.successful {
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        alert.alertStyle = .informational
                        alert.icon = NSImage.init(named: NSImage.menuOnStateTemplateName)
                    
                        alert.messageText = "Successfully Reissued Recovery Key"
                        alert.informativeText = "Successfully reissued the recovery key on this machine.\nNew recovery key: \(String(describing: results.recoveryKey ?? ""))"
                        alert.beginSheetModal(for: self.view.window!) { _ in
                            self.view.window?.close()
                            NSApp.terminate(self)
                        }
                    }
                }
            }
            catch Filevault.FilevaultError.InvalidUsernameOrPassword {
                DispatchQueue.main.async {
                    self.errorLabel.stringValue = "Invalid username or password, please try again."
                    self.errorLabel.isHidden = false
                }
            }
            catch Filevault.FilevaultError.UserNotEnabled {
                DispatchQueue.main.async {
                    
                    // Is this a security risk?
                    self.errorLabel.stringValue = "Invalid username or password, or the user is not enabled for Filevault."
                    self.errorLabel.isHidden = false
                }
            }
            catch {
                print("ERROR")
            }
        }
        //self.view.window?.close()
        //NSApp.abortModal()
        
    }
    
    @IBAction func infoBtnPressed(_ sender: NSButton) {
        
    }


}

