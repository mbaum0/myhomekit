//
//  DeviceViewModel.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import Foundation

class DeviceViewModel: ObservableObject {
    
    static let testDeviceCount = 10
    
    @Published private var model: DeviceModel = generateTestModel()
    
    static func generateTestModel() -> DeviceModel {
        var testDevices: [TogglableDevice] = []
        for k in 1...testDeviceCount {
            testDevices.append(TogglableDevice(name: "Device #\(k)", ipaddr: "127.0.0.1"))
        }
        return DeviceModel(togglableDevices: testDevices)
    }
    
    var togglableDevices: Array<TogglableDevice> {
        return model.togglableDevices
    }
    
    func set(_ device: TogglableDevice, _ status: HomeKitDeviceStatus) {
        return model.set(device, status)
        
    }
}
