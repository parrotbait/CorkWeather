//
//  DatabaseMock.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
@testable import CorkWeather

class DatabaseMock: Database {
    
    var weatherList: WeatherList?
    var dbResult: DatabaseResult?
    var coord: WeatherCoordinate?
    var showOnboarding = true
    var didSave = false
    
    func save(weatherList : WeatherList) {
        // Don't do anything
    }
    
    func load(callback : @escaping DatabaseCallback) {
        callback(dbResult!)
    }
    
    // Get the last picked coordinate
    func lastCoordinatePicked() -> WeatherCoordinate {
        return coord!
    }
    
    func savePickedCoordinate(_ coord: WeatherCoordinate) {
        didSave = true
    }
    
    func shouldShowOnboarding() -> Bool {
        return showOnboarding
    }
}
