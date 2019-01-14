//
//  WeatherCoordinate.swift
//  Cork Weather
//
//  Created by Eddie Long on 05/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import CoreLocation

public typealias LocationDegrees = Double

struct WeatherCoordinate {
    let latitude : LocationDegrees
    let longitude : LocationDegrees
}

extension WeatherCoordinate {
    static func from(coord: CLLocationCoordinate2D) -> WeatherCoordinate {
        return WeatherCoordinate.init(latitude: coord.latitude, longitude: coord.longitude)
    }
}
