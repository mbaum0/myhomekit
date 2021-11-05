//
//  Device.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import Foundation


enum HomeKitDeviceStatus {
    case on
    case off
    case unknown
}

protocol HomeKitDevice {
    var name: String { get set }
    var status: HomeKitDeviceStatus { get set }
    var ipaddr: String { get set }
    
}

struct DeviceModel {
    var togglableDevices: Array<TogglableDevice>
    
    mutating func set(_ device: TogglableDevice, _ status: HomeKitDeviceStatus) {
        if let deviceIndex = togglableDevices.firstIndex(where: {$0.id == device.id}) {
            togglableDevices[deviceIndex].status = status
        }
    }
}

struct TogglableDevice: Identifiable, HomeKitDevice {
    var name: String
    var status: HomeKitDeviceStatus = .unknown
    var ipaddr: String
    let id: UUID = UUID()
    
    init(name: String, ipaddr: String) {
        self.name = name
        self.ipaddr = ipaddr
    }
}
