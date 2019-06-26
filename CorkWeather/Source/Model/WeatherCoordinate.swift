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

struct WeatherCoordinate: Codable {
    let latitude : LocationDegrees
    let longitude : LocationDegrees
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

extension WeatherCoordinate {
    static func from(coord: CLLocationCoordinate2D) -> WeatherCoordinate {
        return WeatherCoordinate.init(latitude: coord.latitude, longitude: coord.longitude)
    }
}

extension WeatherCoordinate: Equatable {
    public static func == (lhs: WeatherCoordinate, rhs: WeatherCoordinate) -> Bool {
        return rhs.latitude == lhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
