//
//  MapsProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import Proteus_Core

typealias PickResult = Result<WeatherLocation, PickError>

protocol MapsProtocol {
    func initialiseMapsApi()
    func showPicker()

    func pickLocation(location : CLLocationCoordinate2D, callback : @escaping ((_ result : PickResult) -> Void))
}
