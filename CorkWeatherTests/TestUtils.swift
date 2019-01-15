//
//  TestUtils.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
@testable import CorkWeather

struct TestUtils {
    static func getMockWeatherObject() -> Weather {
        return Weather.init(description: "des", icon: "icon", id: 123, main: "main", temperature: 10, maxTemperature: 10, minTemperature: 10, windSpeed: 10.0, location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 50, longitude: 0), addressLines: ["My House", "Cork"], postcode: "ABCED EFG"), updateDate: Date())
    }
}
