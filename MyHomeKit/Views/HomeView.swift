//
//  HomeView.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var model: DeviceViewModel
    
    @State private var showNewDeviceView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all).opacity(0.15)
                ScrollView {
                    DeviceButtonView(devices: model.toggleDevices, onTap: model.toggle, onHold: model.del)
                }
            }
            .navigationBarTitle("AutoHome")
            .sheet(isPresented: $showNewDeviceView) {
                NewDeviceView(model: model)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("New Device") {
                        model.add(ToggleDevice(name: "Front Light", ipaddr: "10.0.0.38"))
                        model.add(ToggleDevice(name: "Back Light", ipaddr: "10.0.0.37"))
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("DIY Device") {
                        showNewDeviceView = true
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DeviceButtonView: View {
    let devices: [ToggleDevice]
    let onTap: (ToggleDevice, HomeKitDeviceStatus) -> Void
    let onHold: (ToggleDevice, HomeKitDeviceStatus) -> Void
    var body: some View {
        VStack{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 0) {
                ForEach(devices) { device in
                    CardView(device: device, onTap: onTap, onHold: onHold)
                        .padding(4)
                }
            }
            .padding(.horizontal)
            Spacer(minLength: 0)
        }
    }
}

struct CardView: View {
    let device: ToggleDevice
    let icon = "lightbulb"
    let onTap: (ToggleDevice, HomeKitDeviceStatus) -> Void
    let onHold: (ToggleDevice, HomeKitDeviceStatus) -> Void
    var body: some View {
        VStack {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardRadius)
                if device.status == .unknown {
                    Image("light-unknown")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(DrawingConstants.cardRadius)
                    ProgressView()
                } else if device.status == .error{
                    shape.fill().foregroundColor(.red).opacity(0.75)
                } else {
                    if device.status == .on {
                        Image("light-on")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(DrawingConstants.cardRadius)
                    } else if device.status == .off {
                        Image("light-off")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(DrawingConstants.cardRadius)
                    }
                }
                shape.strokeBorder(lineWidth: DrawingConstants.cardBorderLineWidth)
                    .foregroundColor(.black)
            }
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture {
                if (device.status != .unknown) {
                    onTap(device, device.status)
                }
            }
            .onLongPressGesture(minimumDuration: 0.5) {
                onHold(device, device.status)
            }
            Text(device.name)
                .font(Font.system(size: DrawingConstants.cardTitleFontSize))
                .bold()
        }
    }
    
    private struct DrawingConstants {
        static let cardRadius: CGFloat = 10
        static let cardTitleFontSize: CGFloat = 12
        static let cardIconFontSize: CGFloat = 32
        static let cardBorderLineWidth: CGFloat = 2
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DeviceViewModel()
        HomeView(model: vm)
    }
}
