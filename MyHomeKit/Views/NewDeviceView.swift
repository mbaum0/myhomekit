//
//  NewDeviceView.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/7/21.
//

import SwiftUI

struct NewDeviceView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var model: DeviceViewModel
    
    // MARK: Form related fields
    @State var deviceName: String = ""
    @State var deviceIP: String = ""
    
    struct FormDevice {
        var deviceName: String = ""
        var deviceIP: String = ""
    }
    
    @State var newDev = FormDevice()
    
    var body: some View {
        NavigationView {
            Form(content: {
                Section(header: Text("Device Info")) {
                    TextField("Device Name", text: $newDev.deviceName)
                    TextField("Device IP", text: $newDev.deviceIP)
                }
                
                Button("Create") {
                    model.add(ToggleDevice(name: newDev.deviceName, ipaddr: newDev.deviceIP))
                    self.presentationMode.wrappedValue.dismiss()
                }
                .disabled(newDev.deviceName.isEmpty || newDev.deviceIP.isEmpty)
                
            })
            .navigationTitle("Add New Device")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
