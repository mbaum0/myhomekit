//
//  HomeView.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var model: DeviceViewModel
    
    var body: some View {
        VStack{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 0) {
                ForEach(model.togglableDevices) { device in
                    CardView(device: device)
                        .padding(4)
                        .onTapGesture {
                            model.set(device, device.status == .on ? .off : .on)
                        }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
}



struct CardView: View {
    let device: TogglableDevice
    let icon = "lightbulb"
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardRadius)
            if device.status == .on {
                shape.fill().foregroundColor(.green).opacity(0.75)
            } else if device.status == .off {
                shape.fill().foregroundColor(.gray).opacity(0.75)
            } else {
                shape.fill().foregroundColor(.red).opacity(0.75)
            }
            shape.strokeBorder(lineWidth: DrawingConstants.cardBorderLineWidth)
                .foregroundColor(.black)
            VStack{
                Text(device.name)
                    .font(Font.system(size: DrawingConstants.cardTitleFontSize))
                Image(systemName: icon)
                    .font(Font.system(size: DrawingConstants.cardIconFontSize))
            }
        }
        .aspectRatio(1, contentMode: .fit)
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
