//
//  WeatherViewProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import Proteus_Core

typealias WeatherItemResult = Result<Weather, WeatherLoadError>

protocol WeatherViewProtocol : class {
    func databaseLoaded(result : DatabaseResult)
}
