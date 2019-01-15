//
//  AppConfigTests.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather
import GoogleMaps

class AppConfigTests: XCTestCase {

    func testWeatherUrl() {
        let result = AppConfig.init().getWeatherFetchUrl(latitude: 50, longitude: 50, unit: .celsius)
        switch (result) {
        case .success(let url):
            XCTAssertFalse(url.isEmpty)
        case .failure:
            XCTAssert(false)
        }
    }
    
    /*func testWeatherUrlMissingKey() {
        var config = AppConfig()
        config.weatherAPIKey = ""
        let result = config.getWeatherFetchUrl(latitude: 50, longitude: 50, unit: .celsius)
        switch (result) {
        case .success:
            XCTAssert(false)
        case .failure(let error):
            XCTAssertEqual(error, .missingKey)
        }
    }*/
}
