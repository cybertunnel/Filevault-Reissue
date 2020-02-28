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
        
    }
    
    @IBAction func infoBtnPressed(_ sender: NSButton) {
        
    }


}

