//
//  Shelly.swift
//  MyHomeKit
//
//  Created by Michael Baumgarten on 11/4/21.
//

import Foundation

struct ShellyOneResponse: Decodable {
    var ison: Bool?
    var has_timer: Bool?
    var timer_remaining: Int?
}
