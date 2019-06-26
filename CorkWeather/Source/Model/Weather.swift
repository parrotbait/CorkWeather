//
//  Weather.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import CoreLocation

public typealias WeatherID = Int

struct Weather: Codable {
    let id: WeatherID
    let name: String
    var location: WeatherLocation?
    let coordinate: WeatherCoordinate
    let detail: [WeatherDetail]
    let temperature: WeatherTemperature
    let wind: WindSpeed
    var updateDate: Date?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case location = "location"
        case coordinate = "coord"
        case detail = "weather"
        case temperature = "main"
        case wind = "wind"
        case updateDate = "updateDate"
    }
}

extension Weather: Equatable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
            lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

typealias WeatherList = [Weather]
