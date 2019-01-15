//
//  WeatherCoordinateTests.swift
//  CorkWeather
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather
import CoreLocation

class WeatherCoordinateTests: XCTestCase {
    
    func testFromCoreLocation() {
        let cl = CLLocationCoordinate2D.init(latitude: 10, longitude: 40)
        let coord = WeatherCoordinate.from(coord: cl)
        XCTAssertEqual(Double(cl.latitude), coord.latitude, accuracy: Double.ulpOfOne)
        XCTAssertEqual(Double(cl.longitude), coord.longitude, accuracy: Double.ulpOfOne)
    }

}
