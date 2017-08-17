//
//  WeatherLocation.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

struct WeatherLocation {
    let coordinate : CLLocationCoordinate2D
    let address : GMSAddress
}
