//
//  WeatherViewProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol WeatherViewProtocol : class {
    typealias WeatherListResult = Result<[Weather], InitialiseLoadError>
    func loaded(result : WeatherListResult)
    
    typealias WeatherCallback = Result<Weather, WeatherLoadError>
    func weatherLoaded(result : WeatherCallback)
}
