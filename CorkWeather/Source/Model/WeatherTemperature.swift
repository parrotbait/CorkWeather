//
//  WeatherTemperature.swift
//  CorkWeather
//
//  Created by Eddie Long on 26/06/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

struct WeatherTemperature: Codable {
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
}
