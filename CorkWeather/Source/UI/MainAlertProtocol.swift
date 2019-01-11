//
//  MainAlertProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 25/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol MainAlertProtocol {
    func showWeatherFetchFailure(reason : WeatherLoadError)
 
    typealias RetryCallback = (() -> Void)
    func showWeatherListLoadFailure(reason : DatabaseError, retryCallback: @escaping RetryCallback)
    
    func showWeatherPickError(reason : PickError)
}
