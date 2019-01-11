//
//  WeatherCoordinate+Distance.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

extension WeatherCoordinate {
    func distance(other: WeatherCoordinate) -> Double {
        let R = 6371.0; // Radius of the earth in km
        let diffLatitude = (other.latitude - self.latitude).degreesToRadians;
        let diffLongitude = (other.longitude - self.longitude).degreesToRadians;
        let a =
            sin(diffLatitude / 2) * sin(diffLatitude / 2) +
                cos(self.latitude.degreesToRadians) * cos(other.latitude.degreesToRadians) *
                sin(diffLongitude / 2) * sin(diffLongitude / 2)
        let c = 2.0 * atan2(sqrt(a), sqrt(1 - a))
        let distance = R * c;
        return distance
    }
}
