//
//  WeatherFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol WeatherFetcherProtocol {
    
    // Single weather location
    typealias WeatherCallback = ((_ result : WeatherItemResult) -> Void)
    func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherCallback)
}
