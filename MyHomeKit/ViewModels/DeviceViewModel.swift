//
//  DeviceViewModel.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import Foundation

class DeviceViewModel: ObservableObject {
    
    static let testDeviceCount = 1
    
    @Published private var model: DeviceModel = generateTestModel()
    
    static func generateTestModel() -> DeviceModel {
        var testDevices: [ToggleDevice] = []
        for _ in 1...testDeviceCount {
            testDevices.append(ToggleDevice(name: "Back Light", ipaddr: "10.0.0.37"))
            testDevices.append(ToggleDevice(name: "Front Light", ipaddr: "10.0.0.38"))
            testDevices.append(ToggleDevice(name: "Fake light", ipaddr: "10.0.0.99"))
        }
        return DeviceModel(toggleDevices: testDevices)
    }
    
    init() {
        update()
    }
    
    var toggleDevices: Array<ToggleDevice> {
        return model.toggleDevices
    }
    
    private func setModel(_ dev: ToggleDevice, _ status: HomeKitDeviceStatus) {
        model.set(dev, status)
        
    }
    
    func add(_ dev: ToggleDevice) {
        model.add(dev)
        update(dev)
    }
    
    func del(_ dev: ToggleDevice, _ status: HomeKitDeviceStatus){
        model.del(dev)
    }
    
    func toggle(_ dev: ToggleDevice, _ status: HomeKitDeviceStatus) {
        self.set(dev, status == .on ? .off : .on)
    }
    
    func set(_ dev: ToggleDevice, _ status: HomeKitDeviceStatus) {
        var urlComponents = URLComponents(string:"http://" + dev.ipaddr + "/relay/0")
        urlComponents?.queryItems = [URLQueryItem(name: "turn", value: dev.status == .on ? "off" : "on")]
        let url = urlComponents?.url!
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if err == nil {
                    // decode the JSON response
                    do {
                        let result = try JSONDecoder().decode(ShellyOneResponse.self, from: data!)
                        DispatchQueue.main.async {
                            // set the on state of the relay
                            self.setModel(dev, result.ison! ? .on : .off)
                        }
                    } catch {
                        print("Error occured while setting model \(error)")
                        self.setModel(dev, .unknown)
                    }
                } else {
                   if (err as? URLError)?.code == .timedOut {
                       print("Timed out while fetching model: \(dev)")
                   }
                    self.setModel(dev, .error)
                }
            }.resume()
        }
    }
    
    func update(_ dev: ToggleDevice) {
        let urlComponents = URLComponents(string:"http://" + dev.ipaddr + "/relay/0")
        let url = urlComponents?.url!
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if err == nil {
                    // decode the JSON response
                    do {
                        let result = try JSONDecoder().decode(ShellyOneResponse.self, from: data!)
                        DispatchQueue.main.async {
                            self.setModel(dev, result.ison! ? .on: .off)
                            print("Fetched updated model: \(result)")
                        }
                    } catch {
                        print("Error occured while parsing model")
                        self.setModel(dev, .unknown)
                    }
                } else {
                    if (err as? URLError)?.code == .timedOut {
                        print("Timed out while fetching model: \(dev)")
                    }
                    self.setModel(dev, .error)
                }
            }.resume()
        }
    }
    
    func update() {
        for dev in self.toggleDevices {
            update(dev)
        }
    }
}
