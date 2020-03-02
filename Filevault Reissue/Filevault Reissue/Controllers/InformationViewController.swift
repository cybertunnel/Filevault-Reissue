//
//  InformationViewController.swift
//  Filevault Reissue
//
//  Created by Tyler Morgan on 3/2/20.
//  Copyright © 2020 Tyler Morgan. All rights reserved.
//

import Cocoa

class InformationViewController: NSViewController {

    @IBOutlet weak var informationText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let infoText = Preferences.sharedInstance.moreInformationText {
            self.informationText.stringValue = infoText
        }
    }
    
}
