//
//  ExtensionTests.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather
import GoogleMaps

class ExtensionTests: XCTestCase {
    
    func testWeatherCoordinateDistanceEqual() {
        let coord1 = WeatherCoordinate.init(latitude: 50, longitude: 50)
        let coord2 = WeatherCoordinate.init(latitude: 50, longitude: 50)
        
        XCTAssertLessThan(coord1.distance(other: coord2), Double.ulpOfOne)
    }
    
    func testWeatherCoordinateDistance50Deg() {
        let coord1 = WeatherCoordinate.init(latitude: 50, longitude: 50)
        let coord2 = WeatherCoordinate.init(latitude: 80, longitude: 160)
        
        let dist = coord1.distance(other: coord2)
        // Obtained from: https://stevemorse.org/nearest/distance.php
        // Check if _generally_ right
        XCTAssertLessThan(abs(dist - 4910), 30.0)
    }
    
    func testDateDisplay() {
        XCTAssertEqual(Int(1).getAsString(forUnit: .celsius), ("1 °C"))
        XCTAssertTrue(Int(1).getAsString(forUnit: .fahrenheit).hasSuffix("1 °F"))
        XCTAssertTrue(Int(1).getAsString(forUnit: .kelvin).hasSuffix("1 °K"))
    }
}
