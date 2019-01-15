//
//  WeatherFetcherMock.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
@testable import CorkWeather

class WeatherFetcherMock: WeatherFetcherProtocol {
    
    var result: WeatherItemResult?
    
    func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherCallback) {
        completion(result!)
    }
}
