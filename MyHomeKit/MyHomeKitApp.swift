//
//  MyHomeKitApp.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import SwiftUI

@main
struct MyHomeKitApp: App {
    let vm = DeviceViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView(model: vm)
        }
    }
}
