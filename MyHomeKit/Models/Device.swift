//
//  Device.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import Foundation

// possible statuses of a homekit device
enum HomeKitDeviceStatus {
    case on
    case off
    case unknown
    case error
}

protocol HomeKitDevice {
    var name: String { get set }
    var status: HomeKitDeviceStatus { get set }
    var ipaddr: String { get set }
    var id: UUID { get }
}

struct DeviceModel {
    var toggleDevices: Array<ToggleDevice>
    
    mutating func set(_ device: ToggleDevice, _ status: HomeKitDeviceStatus) {
        if let deviceIndex = toggleDevices.firstIndex(where: {$0.id == device.id}) {
            toggleDevices[deviceIndex].status = status
        }
    }
    
    mutating func add(_ device: ToggleDevice) {
        toggleDevices.append(device)
    }
    
    mutating func del(_ device: ToggleDevice) {
        if let deviceIndex = toggleDevices.firstIndex(where: {$0.id == device.id}) {
            toggleDevices.remove(at: deviceIndex)
        }
    }
}

struct ToggleDevice: Identifiable, HomeKitDevice {
    var name: String
    var status: HomeKitDeviceStatus = .unknown
    var ipaddr: String
    let id: UUID = UUID()
    
    init(name: String, ipaddr: String) {
        self.name = name
        self.ipaddr = ipaddr
    }
}
