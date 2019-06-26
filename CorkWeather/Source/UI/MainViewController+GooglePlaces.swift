//
//  MainViewController+GooglePlaces.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import SWLogger
import Proteus_Core

extension MainViewController : MapsProtocol, GMSPlacePickerViewControllerDelegate {
    
    func showPicker() {
        analytics().logEvent(AnalyticsEvents.showPlacePicker)
        self.coordinator?.showPicker(coordinate: self.viewModel!.getLastPickerCoord(), delegate: self)
    }

    public func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        progressView.show(animated: true)
        analytics().logEvent(AnalyticsEvents.placePicked, [AnalyticsEvents.pickedLongitude : place.coordinate.longitude, AnalyticsEvents.pickedLatitude : place.coordinate.latitude])
        
        let coord = WeatherCoordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.viewModel!.reverseGeocode(location: coord) { (result) in
            // Save the pick location so the map will start in the same place next time
            self.viewModel!.savePickedCoordinate(WeatherCoordinate.from(coord: place.coordinate))
            self.weatherLocationObtained(result: result)
        }
        
        self.coordinator?.hidePicker()
    }
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        Log.e ("Error with place picker \(error)")
        analytics().logEvent(AnalyticsEvents.placePickedError)
        progressView.hide(animated: true)
    }
}
