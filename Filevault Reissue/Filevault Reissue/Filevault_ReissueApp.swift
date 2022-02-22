//
//  Filevault_ReissueApp.swift
//  Filevault Reissue
//
//  Created by Morgan, Tyler on 2/22/22.
//  Copyright © 2022 Tyler Morgan. All rights reserved.
//

import SwiftUI

@main
struct Filevault_ReissueApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 600, height: 450, alignment: .center)
                .environmentObject(FilevaultController())
        }
    }
}
