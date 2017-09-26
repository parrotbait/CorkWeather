//
//  WeatherLocalFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct WeatherLocalFetcher : WeatherFetcherProtocol {
    
    public func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherCallback) {
        if let path = Bundle.main.url(forResource: "CorkResponse", withExtension: "json") {
            if let jsonData = NSData(contentsOf: path) {
                let jsonParser = WeatherJsonParser();
                if let weather : Weather = jsonParser.parse(location : location, jsonData: jsonData) {
                    completion(Result.success(weather))
                }
            }
        }
        completion(Result.failure(WeatherLoadError.backendError));
    }
}
