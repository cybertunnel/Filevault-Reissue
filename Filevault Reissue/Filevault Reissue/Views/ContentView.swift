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
    @State var showMoreInfo: Bool = false
    @State var showSuccess: Bool = false
    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: NSImage.applicationIconName)!)
            Text(Preferences.sharedInstance.viewTitle ?? "Acme Corporation")
                .font(.title)
                .padding()
            Text("Filevault Recovery Key Reissue")
                .font(.title2)
                .padding(10)
            Text(Preferences.sharedInstance.viewInstructions ?? "Out management server does not have a valid recovery key for this device. Please enter the username and password you use to unlock this machine after your system reboots.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(5)
            HStack{
                TextField("japple", text: self.$fvController.user.username)
                SecureField("Password", text: self.$fvController.user.password)
            }
            .padding(10)
            
            Spacer()
            
            HStack {
                Spacer()
                Button("More Information") {
                    self.showMoreInfo.toggle()
                }
                .sheet(isPresented: self.$showMoreInfo) {
                    InformationView(text: "Acme uses the recovery key in our management servers to securely and safely enable your machine to unlock in the event your device has trouble unlocking.\n To learn more visit our IT portal: https://it.acme.com")
                    Button("Close") {
                        self.showMoreInfo.toggle()
                    }
                    .padding()
                }
                Button("Submit") {
                    print("Username: \(self.fvController.user.username), Password: \(self.fvController.user.password)")
                    self.showSuccess.toggle()
                }
                .sheet(isPresented: self.$showSuccess, onDismiss: {NSApp.terminate(self)}) {
                    SuccessView(key: "xxxx-xxxx-xxxx-xxxx")
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
    }
}
