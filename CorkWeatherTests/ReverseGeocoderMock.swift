//
//  ReverseGeocoderMock.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import CoreLocation

@testable import CorkWeather

class ReverseGeocoderMock: ReverseGeocoderProvider {
    
    var pickResult: PickResult?
    
    func reverseGeocode(location : WeatherCoordinate, callback : @escaping GeocoderCallback) {
        callback(pickResult!)
    }
}
