//
//  WeatherTests.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather

class WeatherTests: XCTestCase {
    
    func testEmptyWeatherArray() {
        // given
        
        // when
        
        // then
        XCTAssertNil(Weather.fromArray(source: [String: Any]()))
    }
    
    func testWeatherToArray() {
        // given
        let weather = TestUtils.getMockWeatherObject()
        
        // when
        let array = weather.toArray()
        // What else can be checked here??
        // then
        XCTAssertNotNil(array)
        
        // when
        let weather2 = Weather.fromArray(source: array)
        XCTAssertNotNil(weather2)
        
        // then
        XCTAssertEqual(weather, weather2)
    }
}

