//
//  WeatherCellViewModelTests.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather

class WeatherCellViewModelTests: XCTestCase {

    func testViewModelBasicData() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        var weatherList = WeatherList()
        let weatherObj = TestUtils.getMockWeatherObject()
        weatherList.append(weatherObj)
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.success(weatherList)
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                
                let cellVm = vm.getWeatherViewModelAtIndex(index: 0)
                // then
                XCTAssertNotNil(cellVm)
                if let cell = cellVm {
                    // Add basic checks
                    XCTAssertEqual(cell.desiredUnit, vm.desiredTemperature)
                    XCTAssertFalse(cell.icon.isEmpty)
                    XCTAssertFalse(cell.description.isEmpty)
                    XCTAssertFalse(cell.date.isEmpty)
                    XCTAssertFalse(cell.locationText.isEmpty)
                    XCTAssertFalse(cell.temperature.isEmpty)
                    XCTAssertFalse(cell.maxTemperature.isEmpty)
                    XCTAssertFalse(cell.windSpeed.isEmpty)
                }
            case .failure:
                XCTAssert(false)
            }
        }
        
        // then
    }
    
    func testViewModelBasicDataNoAddress() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        var weatherList = WeatherList()
        var weatherObj = TestUtils.getMockWeatherObject()
        weatherObj.location.addressLines = nil
        weatherList.append(weatherObj)
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.success(weatherList)
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                
                let cellVm = vm.getWeatherViewModelAtIndex(index: 0)
                XCTAssertNotNil(cellVm)
                if let cell = cellVm {
                    // then
                    // Expect no location text
                    XCTAssertTrue(cell.locationText.isEmpty)
                }
            case .failure:
                XCTAssert(false)
            }
        }
    }
}
