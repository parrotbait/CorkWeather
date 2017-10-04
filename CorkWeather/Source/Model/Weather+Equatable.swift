//
//  Weather+Equatable.swift
//  CorkWeather
//
//  Created by Eddie Long on 04/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

extension Weather: Equatable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.location.coordinate.latitude == rhs.location.coordinate.latitude &&
            lhs.location.coordinate.longitude == rhs.location.coordinate.longitude;
    }
}
