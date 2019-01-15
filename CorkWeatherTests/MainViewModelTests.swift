//
//  CorkWeatherTests.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather
import CoreLocation

class CorkWeatherTests: XCTestCase {

    func testOnboarding() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        
        // when
        db.showOnboarding = false
        
        // then
        XCTAssertFalse(vm.shouldShowOnboarding())
        XCTAssertTrue(vm.shouldShowOnboarding(true))
        
        // when
        db.showOnboarding = true
        
        // then
        XCTAssertTrue(vm.shouldShowOnboarding())
        XCTAssertTrue(vm.shouldShowOnboarding(true))
    }
    
    func testDataEmpty() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.success(WeatherList())
        
        // then
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                XCTAssertEqual(vm.numberOfWeatherItems(), 0)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testDatabaseLoadError() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.failure(.noData)
        
        // then
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
    }
    
    func testDatabaseLoadSuccess() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        var weatherList = WeatherList()
        weatherList.append(TestUtils.getMockWeatherObject())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.success(weatherList)
        
        // then
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                XCTAssertEqual(vm.numberOfWeatherItems(), 1)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testViewModelRemoveItem() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        var weatherList = WeatherList()
        weatherList.append(TestUtils.getMockWeatherObject())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.success(weatherList)
        
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                // then
                XCTAssertNotNil(vm.getWeatherViewModelAtIndex(index: 0))
                vm.removeWeatherAtIndex(index: 0)
                XCTAssertEqual(vm.numberOfWeatherItems(), 0)
                //vm.removeWeatherAtIndex(index: 0)
                XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testViewModelLoadSuccess() {
        // given
        let db = DatabaseMock()
        var weatherList = WeatherList()
        weatherList.append(TestUtils.getMockWeatherObject())
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // when
        db.dbResult = DatabaseResult.success(weatherList)
        
        // then
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success:
                XCTAssertEqual(vm.numberOfWeatherItems(), 1)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetcherLoadError() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        var error = WeatherLoadError.backendError
        var weatherList = WeatherList()
        weatherList.append(TestUtils.getMockWeatherObject())
        let geocoder = ReverseGeocoderMock()
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: geocoder)
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        db.dbResult = DatabaseResult.success(weatherList)
        
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success (let items):
                
                // when
                fetcher.result = WeatherItemResult.failure(error)
                
                // then
                vm.fetch(items[0].location, callback: { (fetchResult) in
                    switch (fetchResult) {
                    case .success:
                        XCTAssert(false)
                    case .failure(let error):
                        XCTAssertEqual(error, error)
                    }
                })
                
                // when
                error = WeatherLoadError.badUrl
                fetcher.result = WeatherItemResult.failure(error)
                
                // then
                vm.fetch(items[0].location, callback: { (fetchResult) in
                    switch (fetchResult) {
                    case .success:
                        XCTAssert(false)
                    case .failure(let error):
                        XCTAssertEqual(error, error)
                    }
                })
                
                // when
                error = WeatherLoadError.missingKey
                fetcher.result = WeatherItemResult.failure(error)
                
                // then
                vm.fetch(items[0].location, callback: { (fetchResult) in
                    switch (fetchResult) {
                    case .success:
                        XCTAssert(false)
                    case .failure(let error):
                        XCTAssertEqual(error, error)
                    }
                })
                
                // when
                error = WeatherLoadError.parseError
                fetcher.result = WeatherItemResult.failure(error)
                
                // then
                vm.fetch(items[0].location, callback: { (fetchResult) in
                    switch (fetchResult) {
                    case .success:
                        XCTAssert(false)
                    case .failure(let error):
                        XCTAssertEqual(error, error)
                    }
                })
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testGeocoderLoadError() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        let geocoder = ReverseGeocoderMock()
        var weatherList = WeatherList()
        let weatherObj = TestUtils.getMockWeatherObject()
        weatherList.append(weatherObj)
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: geocoder)
        
        // when
        var error = PickError.backendError
        geocoder.pickResult = PickResult.failure(error)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50.0, longitude: 50.0)) { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure(let errorType):
                XCTAssertEqual(error, errorType)
            }
        }
        
        // when
        error = PickError.jackeen
        geocoder.pickResult = PickResult.failure(error)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50.0, longitude: 50.0)) { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure(let errorType):
                XCTAssertEqual(error, errorType)
            }
        }
        
        // when
        error = PickError.notCork
        geocoder.pickResult = PickResult.failure(error)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50.0, longitude: 50.0)) { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure(let errorType):
                XCTAssertEqual(error, errorType)
            }
        }
        
        // when
        error = PickError.notIreland
        geocoder.pickResult = PickResult.failure(error)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50, longitude: 50.0)) { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure(let errorType):
                XCTAssertEqual(error, errorType)
            }
        }
        
        // when
        error = PickError.alreadyPresent
        geocoder.pickResult = PickResult.failure(error)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50.0, longitude: 50.0)) { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure(let errorType):
                XCTAssertEqual(error, errorType)
            }
        }
        
        // when
        error = PickError.alreadyPresent
        geocoder.pickResult = PickResult.failure(error)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50.0, longitude: 50.0)) { (result) in
            switch (result) {
            case .success:
                XCTAssert(false)
            case .failure(let errorType):
                XCTAssertEqual(error, errorType)
            }
        }
        
        // when
        db.dbResult = DatabaseResult.success(weatherList)
        geocoder.pickResult = PickResult.success(weatherList[0].location)
        
        // then
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success(let weatherList):
                vm.reverseGeocode(location: weatherList[0].location.coordinate, callback: { (pickResult) in
                    switch (pickResult) {
                    case .success:
                        XCTAssert(false)
                    case .failure(let errorType):
                        XCTAssertEqual(errorType, PickError.alreadyPresent)
                    }
                })
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testGeocoderLoadSuccess() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        let geocoder = ReverseGeocoderMock()
        let location = TestUtils.getMockWeatherObject().location
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: geocoder)
        var weatherList = WeatherList()
        weatherList.append(TestUtils.getMockWeatherObject())
        
        // when
        geocoder.pickResult = PickResult.success(location)
        db.dbResult = DatabaseResult.success(weatherList)
        
        // then
        vm.reverseGeocode(location: WeatherCoordinate.init(latitude: 50.0, longitude: 50.0)) { (result) in
            switch (result) {
            case .success(let obj):
                XCTAssertEqual(obj, location)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testTestSaveCoordinate() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: ReverseGeocoderMock())
        
        // when
        vm.savePickedCoordinate(TestUtils.getMockWeatherObject().location.coordinate)
        
        // then
        XCTAssertTrue(db.didSave)
    }
    
    func testFetcherWeatherAlreadyLoadedLoadSuccess() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        let mockWeather = TestUtils.getMockWeatherObject()
        var weatherList = WeatherList()
        weatherList.append(mockWeather)
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: ReverseGeocoderMock())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        let exp = expectation(description: "fetcher_load")
        db.dbResult = DatabaseResult.success(weatherList)
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success (let items):
                // when
                fetcher.result = WeatherItemResult.success(mockWeather)
                
                vm.fetch(items[0].location, callback: { (fetchResult) in
                    // then
                    switch (fetchResult) {
                    case .success(let weatherItem):
                        XCTAssertEqual(mockWeather, weatherItem)
                    case .failure:
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
                
            case .failure:
                XCTAssert(false)
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetcherWeatherNotAlreadyLoadedLoadSuccess() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        let mockWeather = TestUtils.getMockWeatherObject()
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: ReverseGeocoderMock())
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        let exp = expectation(description: "fetcher_load")
        let weatherList = WeatherList()
        db.dbResult = DatabaseResult.success(weatherList)
        vm.loadWeatherList { (result) in
            switch (result) {
            case .success (let items):
                XCTAssertTrue(items.isEmpty)
                // when
                fetcher.result = WeatherItemResult.success(mockWeather)
                
                vm.fetch(mockWeather.location, callback: { (fetchResult) in
                    // then
                    switch (fetchResult) {
                    case .success(let weatherItem):
                        XCTAssertEqual(mockWeather, weatherItem)
                    case .failure:
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
                
            case .failure:
                XCTAssert(false)
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testVIewModelErrorNoData() {
        // given
        let db = DatabaseMock()
        let fetcher = WeatherFetcherMock()
        let vm = MainViewModel.init(fetcher: fetcher, database: db, reverseGeocoder: ReverseGeocoderMock())
        
        // when
        XCTAssertEqual(vm.numberOfWeatherItems(), 0)
        XCTAssertNil(vm.getWeatherViewModelAtIndex(index: 0))
        
        // then
        expectFatalError {
            vm.removeWeatherAtIndex(index: 0)
        }
    }
    
    func testPickerLocation() {
        // given
        let db = DatabaseMock()
        let vm = MainViewModel.init(fetcher: WeatherFetcherMock(), database: db, reverseGeocoder: ReverseGeocoderMock())
        
        // when
        db.coord = WeatherCoordinate.init(latitude: 50, longitude: 10)
        
        // then
        XCTAssertEqual(vm.getLastPickerCoord().latitude, db.coord?.latitude)
        XCTAssertEqual(vm.getLastPickerCoord().longitude, db.coord?.longitude)
    }

}
