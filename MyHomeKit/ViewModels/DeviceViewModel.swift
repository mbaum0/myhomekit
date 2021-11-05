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
            testDevices.append(TogglableDevice(name: "Back Light (\(k))", ipaddr: "10.0.0.37"))
            testDevices.append(TogglableDevice(name: "Front Light (\(k)", ipaddr: "10.0.0.38"))
        }
        return DeviceModel(togglableDevices: testDevices)
    }
    
    var togglableDevices: Array<TogglableDevice> {
        return model.togglableDevices
    }
    
    private func setModel(_ device: TogglableDevice, _ status: HomeKitDeviceStatus) {
        return model.set(device, status)
        
    }
    
    func set(_ device: TogglableDevice, _ status: HomeKitDeviceStatus) {
        
        var urlComponents = URLComponents(string:"http://" + device.ipaddr + "/relay/0")
        urlComponents?.queryItems = [URLQueryItem(name: "turn", value: device.status == .on ? "off" : "on")]
        let url = urlComponents?.url!
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if err == nil {
                    // decode the JSON response
                    do {
                        let result = try JSONDecoder().decode(ShellyOneResponse.self, from: data!)
                        DispatchQueue.main.async {
                            // set the on state of the relay
                            self.setModel(device, result.ison! ? .on : .off )
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
