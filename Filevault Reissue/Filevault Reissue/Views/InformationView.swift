//
//  InformationView.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import SwiftUI

struct InformationView: View {
    @State var text: String
    var body: some View {
        VStack {
            Text("More Information")
                .font(.title2)
                .padding()
            Divider()
            Text(text)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(text:"Acme uses the recovery ke yin out management servers to securely and safely enable your machine to unlock in the event your device has trouble unlocking.\nTo learn more visit our IT portal: https://it.acme.com")
    }
}
