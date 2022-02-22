//
//  SuccessView.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import SwiftUI

struct SuccessView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var key: String
    var body: some View {
        VStack {
            Text("Successfully Reissued Recovery Key")
                .font(.title2)
                .padding(5)
            Text("Successfully reissued your recovery key on this machine.")
            Text("New Recovery Key: \(self.key)")
            Button("Quit") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(5)
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(key: "xxxx-xxxx-xxx-xxxxx-xxxx")
    }
}

