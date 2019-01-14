//
//  GMSPlacePickerConfig+Coords.swift
//  CorkWeather
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlacePicker

extension GMSPlacePickerConfig {
    static func create(coordinate: WeatherCoordinate, zoomSize: Double) -> GMSPlacePickerConfig {
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + zoomSize, longitude: center.longitude + zoomSize)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - zoomSize, longitude: center.longitude - zoomSize)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        return GMSPlacePickerConfig(viewport: viewport)
    }
}
