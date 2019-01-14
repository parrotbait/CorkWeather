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
        let worldRadius = 6371.0; // Radius of the earth in km
        let diffLatitude = (other.latitude - self.latitude).degreesToRadians
        let diffLongitude = (other.longitude - self.longitude).degreesToRadians
        let angle =
            sin(diffLatitude / 2) * sin(diffLatitude / 2) +
                cos(self.latitude.degreesToRadians) * cos(other.latitude.degreesToRadians) *
                sin(diffLongitude / 2) * sin(diffLongitude / 2)
        let cOut = 2.0 * atan2(sqrt(angle), sqrt(1 - angle))
        let distance = worldRadius * cOut
        return distance
    }
}
