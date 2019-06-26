//
//  WindSpeed.swift
//  CorkWeather
//
//  Created by Eddie Long on 26/06/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

struct WindSpeed: Codable {
    let speed: Double
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }
}
