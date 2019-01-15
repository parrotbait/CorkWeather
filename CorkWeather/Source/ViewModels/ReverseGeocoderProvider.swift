//
//  MapProvider.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import CoreLocation

protocol ReverseGeocoderProvider {
    typealias GeocoderCallback = (_ result : PickResult) -> Void
    func reverseGeocode(location : WeatherCoordinate, callback : @escaping GeocoderCallback)
}
