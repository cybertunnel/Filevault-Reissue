//
//  ContentView.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fvController: FilevaultController
    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: NSImage.applicationIconName)!)
                .padding()
            Text(Preferences.sharedInstance.viewTitle ?? "Acme Corporation")
                .font(.title)
                .padding()
            Text("Filevault Recovery Key Reissue")
                .font(.title2)
                .padding(10)
            Text(Preferences.sharedInstance.viewInstructions ?? "Our management server does not have a valid recovery key for this device. Please enter the username and password you use to unlock this machine after your system reboots.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(5)
            HStack{
                TextField("japple", text: self.$fvController.user.username)
                    .disabled(self.fvController.inProgress)
                    .disableAutocorrection(true)
                SecureField("Password", text: self.$fvController.user.password)
                    .disabled(self.fvController.inProgress)
                    .disableAutocorrection(true)
            }
            .padding(10)
            
            if let msg = self.fvController.errorMsg {
                Text(msg)
                    .font(.callout)
                    .foregroundColor(.red)
                    
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("More Information") {
                    self.fvController.showInfo.toggle()
                }
                .sheet(isPresented: self.$fvController.showInfo) {
                    InformationView(text: "Acme uses the recovery key in our management servers to securely and safely enable your machine to unlock in the event your device has trouble unlocking.\n To learn more visit our IT portal: https://it.acme.com")
                    Button("Close") {
                        self.fvController.showInfo.toggle()
                    }
                    .padding()
                }
                Button("Submit") {
                    self.fvController.reissueKey()
                }
                .keyboardShortcut(.return)
                .disabled(self.fvController.inProgress)
                .sheet(isPresented: self.$fvController.showSuccess, onDismiss: {NSApp.terminate(self)}) {
                    SuccessView(key: self.$fvController.newKey.wrappedValue ?? "Not configured")
                        .padding()
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let vcController = FilevaultController()
        ContentView()
            .frame(width: 600, height: 450, alignment: .center)
            .environmentObject(vcController)
        
        let otherVCController = { () -> FilevaultController in
            let controller = FilevaultController()
            controller.errorMsg = "Example Error"
            return controller
        }()
        ContentView()
            .frame(width: 600, height: 450, alignment: .center)
            .environmentObject(otherVCController)
    }
}
